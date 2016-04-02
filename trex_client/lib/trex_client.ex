defmodule TrexServerClient do
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
    IO.inspect "closing connection"

    :gen_tcp.close(state)
  end
end

defmodule TrexClient.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(TrexServerClient, ['127.0.0.1', 4040])
    ]

    supervise(children, strategy: :one_for_one, restart: :permament)
  end
end

defmodule TrexClient do
  def main(args) do
    TrexClient.Supervisor.start_link

    loop
  end

  def loop do
    command = IO.gets("127.0.0.1:4040> ")

    reply = TrexServerClient.command(String.replace(command, " ", "\t"))

    IO.puts reply

    loop
  end
end
