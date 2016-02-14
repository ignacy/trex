defmodule TrexServer do
  require Logger

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Task.Supervisor, [[name: TrexServer.Server.TaskSupervisor]]),
      worker(Task, [TrexServer.Server, :accept, [4040]])
    ]

    opts = [strategy: :one_for_one, name: TrexServer.Server.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
