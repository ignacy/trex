defmodule TrexStorage do
  defstruct file:

  @line_separator "\t"

  def start_link do
    Agent.start_link(
    fn ->
      {:ok, file} = File.open("trex.dat", [:append])
      memory = "trex.dat" |> File.stream!([:read], :line) |> read_current_state

      {file, memory}
    end,
    name: __MODULE__)
  end

  def read_current_state(stream) do
    stream
    |> splitted
    |> Enum.reduce(Map.new, fn {_, key, value}, acc ->
      Map.put(acc, key, value)
    end)
  end

  def get(key) do
    file = Agent.get(__MODULE__, fn {file, memory} ->
      memory[key]
    end)
  end

  def put(key, value) do
    Agent.update(__MODULE__, fn {file, memory} ->
      IO.puts(file, wal_line(key, value))
      {file, Map.put(memory, key, value)}
    end)
  end

  def keys do
    Agent.get(__MODULE__, fn {file, memory} ->
      Map.keys(memory)
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
