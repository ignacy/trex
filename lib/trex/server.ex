defmodule Trex.Server do
  @moduledoc """
  Provides code for seting up server and accepting connections.
  """

  alias Trex.{Storage, Handler}
  require Logger

  def accept do
    Storage.start
    opts = [port: System.get_env("TREX_PORT") || 4040]

    case :ranch.start_listener(:Trex, 100, :ranch_tcp, opts, Handler, []) do
      {:ok, _} -> Logger.info "Application started"
      {:error, _} -> Logger.info "Started with problems"
    end
  end
end
