defmodule TrexCLI.Client do
  use GenServer

  def start_link(host, port) do
    GenServer.start_link(__MODULE__, {host, port}, [name: __MODULE__])
  end

  def init({host, port}) do
    Process.flag(:trap_exit, true)

    opts = [:binary, active: false]

    :gen_tcp.connect(host, port, opts)
  end

  def command(command) do
    GenServer.call(__MODULE__, command)
  end

  def handle_call(command, _from, socket) do
    :gen_tcp.send(socket, command)

    case :gen_tcp.recv(socket, 0) do
      {:ok, msg} -> {:reply, msg, socket}
      {:error, msg} -> {:stop, "Connection refused", :reply, socket}
    end
  end

  def terminate(_reason, state) do
    :gen_tcp.close(state)
  end
end
