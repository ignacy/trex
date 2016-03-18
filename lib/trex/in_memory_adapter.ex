defmodule Trex.InMemoryAdapter do
  use GenServer
  require Logger

  def start_link(_args) do
    GenServer.start_link(__MODULE__, Map.new, [name: :trex_storage])
  end

  def get(server, key) do
    GenServer.call(server, {:get, key})
  end

  def put(server, key, value) do
    GenServer.cast(server, {:put, key, value})
  end

  def keys(server) do
    GenServer.call(server, :keys)
  end

  def handle_call({:get, key}, _from, state) do
    {:reply, Map.fetch(state, key), state}
  end

  def handle_call(:keys, _from, state) do
    {:reply, Map.keys(state), state}
  end

  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  def terminate(reason, state) do
    Logger.info "Asked to stop because #{inspect reason}"
    Logger.info "State when stoping #{inspect state}"
    {:ok, state}
  end
end
