defmodule TrexServerClient do
  use GenServer

  def start_link(host, port) do
    IO.inspect("try to restart")
    GenServer.start_link(__MODULE__, {host, port}, [name: __MODULE__])
  end

  def init({host, port}) do
    IO.inspect("try to restart")
    Process.flag(:trap_exit, true)

    opts = [:binary, active: false]
    :gen_tcp.connect(host, port, opts)
  end

  def command(command) do
    case GenServer.call(__MODULE__, command) do
      reply -> reply
      otherwise -> "Connection error"
    end
  end

  def handle_call(command, _from, socket) do
    :gen_tcp.send(socket, command)

    case :gen_tcp.recv(socket, 0) do
      {:ok, msg } -> {:reply, msg, socket}
      {:error, reason } -> {:stop, :normal}
    end
  end

  def terminate(_reason, state) do
    IO.inspect "closing connection"

    :gen_tcp.close(state)
  end
end

defmodule TrexPrompt do
  def start_link do
    IO.inspect "Starting.."
    loop
  end

  defp loop do
    command = IO.gets("127.0.0.1:4040> ")

    reply = TrexServerClient.command(String.replace(command, " ", "\t"))

    loop
  end
end

defmodule TrexClient do
  def main(args) do
    run(TrexServerClient)
  end

  def run(mod) do
    import Supervisor.Spec

    children = [
      worker(TrexServerClient, ['127.0.0.1', 4040]),
      worker(TrexPrompt, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one, restart: :permament)
  end
end
