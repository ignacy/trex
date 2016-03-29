defmodule Trex.Storage do
  use GenServer

  @line_separator "\t"
  @table_name :data

  def init(filename) do
    :dets.open_file(@table_name, [file: filename, type: :set])
  end

  def start_link(filename \\ "trex.dets") do
    GenServer.start_link(__MODULE__, filename, [name: :trex_storage])
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  def put(pid, key, value) do
    GenServer.cast(pid, {:put, key, value})
  end

  def keys(pid) do
    GenServer.call(pid, :keys)
  end

  def handle_cast({:put, key, value}, state) do
    :dets.insert(@table_name, {key, value})
    {:noreply, state}
  end

  def handle_call({:get, key}, _from, state) do
    case :dets.lookup(@table_name, key) do
      [{_key, v}|_tail] ->
        {:reply, v, state}
      [] ->
        {:reply, nil, state}
    end
  end

  def handle_call(:keys, _from, state) do
    keys_list = :dets.select(@table_name, [{{:"$1", :"_"}, [], [:"$1"]}])
    {:reply, keys_list, state}
  end

  def terminate(_reason, state) do
    :dets.close(state)
    :ok
  end
end
