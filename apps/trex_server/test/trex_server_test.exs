defmodule TrexServerTest do
  use ExUnit.Case

  setup do
    Application.stop(:trex_server)
    :ok = Application.start(:trex_server)
  end

  setup do
    opts = [:binary, packet: :line, active: false]
    {:ok, socket} = :gen_tcp.connect('localhost', 4040, opts)
    {:ok, socket: socket}
  end

  test "server interaction", %{socket: socket} do
    assert send_and_recv(socket, "PING\r\n") == "PONG\r\n"

    assert send_and_recv(socket, "SET\tSOMEKEY\tSOMEVALUE\r\n") == "OK\r\n"
    assert send_and_recv(socket, "GET\tSOMEKEY\r\n") == "SOMEVALUE\r\n"

    assert send_and_recv(socket, "LIST\r\n") =~ "SOMEKEY\r\n"

    assert send_and_recv(socket, "NOT_IMPLEMENTED\r\n") == "Unknown command: not_implemented\r\n"
    assert send_and_recv(socket, "GET\tKEY\t\ARG1\r\n") == "Wrong number of arguments - get takes VALUE argument\r\n"
  end

  defp send_and_recv(socket, command) do
    :ok = :gen_tcp.send(socket, command)
    case :gen_tcp.recv(socket, 0, 1000) do
      {:ok, data} -> data
      {:error, err} -> err
    end
  end
end
