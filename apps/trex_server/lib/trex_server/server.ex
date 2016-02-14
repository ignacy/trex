defmodule TrexServer.Server do
  alias TrexServer.{CommandEvaluator, WriteAheadLog, Server.TaskSupervisor}
  require Logger

  @storage_adapter WriteAheadLog

  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port,
    [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info "Accepting connections on port #{port}"

    loop_acceptor(socket, @storage_adapter.new)
  end

  defp loop_acceptor(socket, storage) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child TaskSupervisor, fn ->
      serve(client, storage)
    end
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket, storage)
  end

  defp serve(socket, storage) do
    {msg, new_storage} =
    case read_line(socket) do
      {:ok, data} ->
        CommandEvaluator.evaluate(data, @storage_adapter, storage)
      {:error, _} = err ->
        {err, storage}
    end

    write_line(socket, msg)
    serve(socket, new_storage)
  end

  defp read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end

  defp write_line(socket, {:ok, command}) do
    :gen_tcp.send(socket, command <> "\r\n")
  end

  defp write_line(socket, {:error, :unknown_command}) do
    :gen_tcp.send(socket, "UNKNOWN COMMAND\r\n")
  end

  defp write_line(_socket, {:error, :closed}) do
    exit(:shutdown)
  end

  defp write_line(socket, {:error, error}) do
    :gen_tcp.send(socket, "ERROR\r\n")
    exit(error)
  end
end
