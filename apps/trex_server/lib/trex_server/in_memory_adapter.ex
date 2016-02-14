defmodule TrexServer.InMemoryAdapter do
  def start_link do
    Agent.start_link(fn -> Map.new end, name: __MODULE__)
  end

  def get(key) do
    file = Agent.get(__MODULE__, fn state ->
      state[key]
    end)
  end

  def put(key, value) do
    Agent.update(__MODULE__, fn state ->
      Map.put(state, key, value)
    end)
  end

  def keys do
    Agent.get(__MODULE__, fn state ->
      Map.keys(state)
    end)
  end
end
