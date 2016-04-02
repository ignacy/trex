defmodule TrexServerClient do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_state) do
    opts = [:binary, active: false]
    :gen_tcp.connect('127.0.0.1', 4040, opts)
  end

  def command(pid, command) do
    IO.inspect command

    GenServer.call(pid, command)
  end

  def handle_call(command, from, socket) do
    :ok = :gen_tcp.send(socket, command)
    {:ok, msg} = :gen_tcp.recv(socket, 0)

    {:reply, msg, socket}
  end

  def cmd(command) do
    "#{command}\r\n"
  end
end

defmodule TrexClient do
  def main(args) do
    {:ok, pid} = TrexServerClient.start_link

    loop(pid)
  end

  def loop(pid) do
    command = IO.gets("127.0.0.1:4040> ")

    reply = TrexServerClient.command(pid, String.replace(command, " ", "\t"))
    IO.puts reply

    loop(pid)
  end
end
