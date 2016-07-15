defmodule Trex.Server do
  use GenServer

  @moduledoc """
  Provides code for seting up Storge and TCP connection pool.
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

    case :ranch.start_listener(:Trex, 100, :ranch_tcp, opts, Handler, []) do
      {:ok, _} -> Logger.info "Application started"
      {:error, reason} -> Logger.error "Started with problems: #{inspect reason}"
    end

    {:ok, %{}}
  end

  def handle_info(message, state) do
    Logger.info "Server received #{inspect message}"
    {:noreply, state}
  end
end
