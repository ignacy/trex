defmodule TrexCLI.Supervisor do
  use Supervisor

  def start_link(host, port) do
    Supervisor.start_link(__MODULE__, {host, port})
  end

  def init({host, port}) do
    children = [
      worker(TrexCLI.Client, [host, port])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
