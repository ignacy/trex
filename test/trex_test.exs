defmodule TrexTest do
  use ExUnit.Case

  setup do
    Application.stop(:trex)
    :ok = Application.start(:trex)
  end

  setup do
    opts = [:binary, packet: :line, active: false]
    {:ok, socket} = :gen_tcp.connect('localhost', 4040, opts)
    {:ok, socket: socket}
  end

  test "server interaction", %{socket: socket} do
    assert send_and_recv(socket, "PING\r\n") == "PONG\r\n"

    assert send_and_recv(socket, "NOT_IMPLEMENT\r\n") == "UNKNOWN COMMAND\r\n"
  end

  defp send_and_recv(socket, command) do
    :ok = :gen_tcp.send(socket, command)
    {:ok, data} = :gen_tcp.recv(socket, 0, 1000)
    data
  end
end
