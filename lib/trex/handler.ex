defmodule Trex.Handler do
  alias Trex.{CommandEvaluator}
  require Logger

  def start_link(ref, socket, transport, opts) do
    pid = spawn_link(__MODULE__, :init, [ref, socket, transport, opts])
    {:ok, pid}
  end

  def init(ref, socket, transport, _Opts = []) do
    :ok = :ranch.accept_ack(ref)
    loop(socket, transport)
  end

  def loop(socket, transport) do
    case transport.recv(socket, 0, 5000) do
      {:ok, data} ->
        write_line(transport, socket, CommandEvaluator.evaluate(data))

        # If you want to run redis-benchmark you need this:
        # write_line(transport, socket, {:ok, "+PONG"})
        # we probably want to adjust the format we're handling here

        loop(socket, transport)
      _ ->
        :ok = transport.close(socket)
    end
  end

  defp write_line(transport, socket, {:ok, command}) do
    transport.send(socket, to_string(command) <> "\r\n")
  end

  defp write_line(transport, socket, {:error, :unknown_command}) do
    transport.send(socket, "UNKNOWN_COMMAND\r\n")
  end

  defp write_line(_transport, _socket, {:error, :closed}) do
    exit(:shutdown)
  end

  defp write_line(transport, socket, {:error, error}) do
    transport.send(socket, "ERROR\r\n")
    exit(error)
  end

  defp write_line(transport, socket, message) do
    transport.send(socket, "#{inspect message}\r\n")
    exit(:shutdown)
  end
end
