defmodule TrexServer.Server do
  alias TrexServer.{CommandEvaluator, Server.TaskSupervisor}
  require Logger

  @port System.get_env("TREX_PORT") || 4040
  @storage_file    System.get_env("TREX_STORAGE_FILE") || "trex.dat"
  @storage_adapter Application.get_env(:trex_server, :storage_adapter)

  def accept do
    {:ok, socket} = :gen_tcp.listen(@port,
    [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info "Accepting connections on port #{@port}"

    {:ok, storage_pid} = @storage_adapter.start_link(@storage_file)
    Process.register(storage_pid, :trex_storage)
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child TaskSupervisor, fn ->
      serve(client)
    end
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    msg =
    case read_line(socket) do
      {:ok, data} ->
        Logger.info "Processing #{data}"
        CommandEvaluator.evaluate(data)
      err -> err
    end

    write_line(socket, msg)
    serve(socket)
  end

  defp read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end

  defp write_line(socket, {:ok, command}) do
    :gen_tcp.send(socket, to_string(command) <> "\r\n")
  end

  defp write_line(socket, {:error, :unknown_command}) do
    :gen_tcp.send(socket, "UNKNOWN_COMMAND\r\n")
  end

  defp write_line(_socket, {:error, :closed}) do
    exit(:shutdown)
  end

  defp write_line(socket, {:error, error}) do
    :gen_tcp.send(socket, "ERROR\r\n")
    exit(error)
  end

  defp write_line(socket, message) do
    Logger.error "Unexpected command result #{message}"
    :gen_tcp.send(socket, "#{inspect message}\r\n")
    exit(:shutdown)
  end
end
