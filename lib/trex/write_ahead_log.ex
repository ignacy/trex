defmodule Trex.WriteAheadLog do
  defstruct logfile: "trex_data"

  alias Trex.WriteAheadLog

  def new(logfile \\ "trex_data") do
    {:ok, file } = File.open(logfile, [:append])
    File.close(file)

    %WriteAheadLog{logfile: logfile}
  end

  def get(%WriteAheadLog{logfile: logfile}, key) do
    case logfile |> File.stream! |> search_for_key(key) do
      {:ok, {_timestamp, _operation, _key, value}} -> value |> String.rstrip
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
    logfile |> File.stream! |> _keys
  end

  defp wal_line(key, value) do
    [:os.system_time(:seconds), "SET", key, value]
    |> Enum.join(":")
  end

  defp _keys(stream) do
    Enum.map stream, fn(line) ->
      {_timestamp, _operation, key, _value} = line
      |> String.split(":")
      |> List.to_tuple

      key
    end
  end

  defp search_for_key(stream, sought_key) do
    stream
    |> Enum.map(fn(line) ->
      line |> String.split(":") |> List.to_tuple
    end)
    |> Enum.filter(fn({_timestamp, _operation, key, _value}) ->
      key == sought_key
    end)
    |> Enum.fetch(-1)
  end
end
