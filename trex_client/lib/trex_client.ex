defmodule TrexServerClient do
  use GenServer

  def start_link(host, port) do
    GenServer.start_link(__MODULE__, {host, port}, [name: __MODULE__])
  end

  def init({host, port}) do
    opts = [:binary, active: false]
    :gen_tcp.connect(host, port, opts)
  end

  def command(command) do
    GenServer.call(__MODULE__, command)
  end

  def handle_call(command, _from, socket) do
    :ok = :gen_tcp.send(socket, command)
    {:ok, msg} = :gen_tcp.recv(socket, 0)

    {:reply, msg, socket}
  end
end

defmodule TrexClient do
  def main(args) do
    run(TrexServerClient)
  end

  def run(mod) do
    import Supervisor.Spec

    children = [worker(TrexServerClient, ['127.0.0.1', 4040])]

    Supervisor.start_link(children, strategy: :one_for_one)

    loop
  end

  def loop do
    command = IO.gets("127.0.0.1:4040> ")

    reply = TrexServerClient.command(String.replace(command, " ", "\t"))
    IO.puts reply

    loop
  end
end
