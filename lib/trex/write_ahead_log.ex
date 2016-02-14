defmodule Trex.WriteAheadLog do
  defstruct logfile: "trex_data"

  alias Trex.WriteAheadLog

  @line_separator "\t"

  def new(logfile \\ "trex_data") do
    {:ok, file } = File.open(logfile, [:append])
    File.close(file)

    %WriteAheadLog{logfile: logfile}
  end

  def get(%WriteAheadLog{logfile: logfile}, key) do
    case logfile |> File.stream! |> search_for_key(key) do
      {_timestamp, _key, value} -> String.rstrip(value)
      _otherwise -> nil
    end
  end

  def put(wal = %WriteAheadLog{logfile: logfile}, key, value) do
    {:ok, file} = File.open(logfile, [:append])
    IO.puts(file, wal_line(key, value))
    File.close(file)

    wal
  end

  def keys(%WriteAheadLog{logfile: logfile}) do
    logfile
    |> File.stream!
    |> splited
    |> Enum.into([], fn {_, key, _} -> key end)
    |> Enum.uniq
  end

  defp wal_line(key, value) do
    [:os.system_time(:seconds), key, value]
    |> Enum.join(@line_separator)
  end

  defp search_for_key(stream, sought_key) do
    stream
    |> splited
    |> Enum.find(&matches_key?(sought_key, &1))
  end

  defp break_line(line), do: line |> String.split(@line_separator) |> List.to_tuple
  defp matches_key?(sought_key, {_timestamp, key, _value}), do: key == sought_key
  defp non_empty?(line), do: String.strip(line) != ""

  defp splited(stream) do
    stream
    |> Enum.filter(&non_empty?/1)
    |> Enum.map(&break_line/1)
  end
end
