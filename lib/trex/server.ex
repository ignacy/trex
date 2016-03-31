defmodule Trex.Server do
  alias Trex.{ConnectionHandler, Server.TaskSupervisor}
  require Logger


  def accept do
    port = System.get_env("TREX_PORT") || 4040

    {:ok, socket} = :gen_tcp.listen(port,
    [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info "Accepting connections on port #{port}"

    loop(socket)
  end

  defp loop(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child TaskSupervisor, fn ->
      ConnectionHandler.serve(client)
    end
    :ok = :gen_tcp.controlling_process(client, pid)
    loop(socket)
  end
end
