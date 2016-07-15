defmodule Trex.Server do
  use GenServer

  @moduledoc """
  Provides code for seting up server and accepting connections.
  """

  alias Trex.{Storage, Handler}
  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  ## Server Callbacks

  def init(:ok) do
    Storage.start
    opts = [port: System.get_env("TREX_PORT") || 4040]

    Logger.info "Starting ranch pool"

    case :ranch.start_listener(:Trex, 100, :ranch_tcp, opts, Handler, []) do
      {:ok, _} -> Logger.info "Application started"
      {:error, _} -> Logger.info "Started with problems"
    end

    {:ok, %{}}
  end

  def handle_info(anything, state) do
    Logger.info "Server received #{IO.inspect(anything)}"
    {:noreply, state}
  end
end
