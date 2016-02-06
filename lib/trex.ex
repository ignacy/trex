defmodule Trex do
  require Logger

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Task.Supervisor, [[name: Trex.Server.TaskSupervisor]]),
      worker(Task, [Trex.Server, :accept, [4040]])
    ]

    opts = [strategy: :one_for_one, name: Trex.Server.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
