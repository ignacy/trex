defmodule Trex do
  require Logger

  @storage_adapter Application.get_env(:trex, :storage_adapter)
  @storage_file    System.get_env("TREX_STORAGE_FILE") || "trex.dat"

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Task.Supervisor, [[name: Trex.Server.TaskSupervisor]]),
      worker(Task, [Trex.Server, :accept, []]),
      worker(@storage_adapter, [@storage_file])
    ]

    opts = [strategy: :one_for_one, name: Trex.Server.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
