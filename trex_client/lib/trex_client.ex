defmodule TrexServerClient do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, [name: :trex_client])
  end

  def init(_state) do
    opts = [:binary, active: false]
    :gen_tcp.connect('127.0.0.1', 4040, opts)
  end

  def command(command) do
    IO.inspect command

    GenServer.call(:trex_client, command)
  end

  def handle_call(command, from, socket) do
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
    mod.start_link

    loop
  end

  def loop do
    command = IO.gets("127.0.0.1:4040> ")

    reply = TrexServerClient.command(String.replace(command, " ", "\t"))
    IO.puts reply

    loop
  end
end
