defmodule Trex do
  require Logger

  def start(_type, _args) do
    storage_adapter = Application.get_env(:trex, :storage_adapter)
    storage_file = System.get_env("TREX_STORAGE_FILE") || "trex.dets"

    import Supervisor.Spec

    children = [
      supervisor(Task.Supervisor, [[name: Trex.Server.TaskSupervisor]]),
      worker(Task, [Trex.Server, :accept, []]),
      worker(storage_adapter, [storage_file], shutdown: 500)
    ]

    opts = [strategy: :one_for_one, name: Trex.Server.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
