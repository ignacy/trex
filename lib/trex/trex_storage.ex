defmodule Trex.Storage do
  use GenServer

  @line_separator "\t"

  def init(filename) do
    Agent.start_link(
      fn ->
        {:ok, file} = File.open(filename, [:append])
        memory = filename
        |> File.stream!([:read], :line)
        |> read_current_state

        {file, memory}
      end,
      name: __MODULE__)
  end

  def start_link(filename \\ "trex.dat") do
    GenServer.start_link(__MODULE__, filename)
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
    Agent.update(__MODULE__, fn {file, memory} ->
      IO.puts(file, wal_line(key, value))
      {file, Map.put(memory, key, value)}
    end)

    {:noreply, state}
  end

  def handle_call({:get, key}, _from, state) do
    file = Agent.get(__MODULE__, fn {_, memory} ->
      memory[key]
    end)

    {:reply, file, state}
  end

  def handle_call(:keys, _from, state) do
    list = Agent.get(__MODULE__, fn {_, memory} ->
      Map.keys(memory)
    end)

    {:reply, list, state}
  end

  ### --- old code below

  defp read_current_state(stream) do
    stream
    |> splitted
    |> Enum.reduce(Map.new, fn {_, key, value}, acc ->
      Map.put(acc, key, value)
    end)
  end

  defp wal_line(key, value) do
    [:os.system_time(:seconds), key, value]
    |> Enum.join(@line_separator)
  end

  defp splitted(stream) do
    stream
    |> Enum.filter(&non_empty?/1)
    |> Enum.map(&break_line/1)
  end

  defp break_line(line), do: line |> String.split(@line_separator) |> List.to_tuple
  defp non_empty?(line), do: String.strip(line) != ""
end
