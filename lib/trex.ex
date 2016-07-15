defmodule Trex do
  @moduledoc """
  The main entry point of Trex server.

  There's one Trex.Server process worker and one Task supervisor being
  started here. Server process accepts TCP connections and uses
  separate tasks to handle them.

  """
  require Logger

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Task.Supervisor, [[name: Trex.Server.TaskSupervisor]]),
      worker(Trex.Server, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
