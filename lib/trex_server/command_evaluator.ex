defmodule TrexServer.CommandEvaluator do
  @message_separator "\t"

  def evaluate(line, storage_adapter, storage) do
    line |> parse |> _evaluate(storage_adapter, storage)
  end

  defp parse(line) do
    case cleanup(line) do
      ["PING"] -> :ping
      ["GET", key] -> {:get, key}
      ["SET", key, value] -> {:set, key, value}
      ["LIST"] -> :list
      _ -> {:error, :unknown_command}
    end
  end

  defp _evaluate(:ping, _storage_adapter, storage) do
    {{:ok, "PONG"}, storage}
  end

  defp _evaluate({:get, key}, storage_adapter, storage) do
    {{:ok, "#{storage_adapter.get(storage, key)}"}, storage}
  end

  defp _evaluate({:set, key, value}, storage_adapter, storage) do
    {{:ok, "OK"}, storage_adapter.put(storage, key, value)}
  end

  defp _evaluate(:list, storage_adapter, storage) do
    {{:ok, storage |> storage_adapter.keys |> Enum.join(",")}, storage}
  end

  defp _evaluate(error, _storage_adapter, storage) do
    {error, storage}
  end

  defp cleanup(line) do
    line |> String.rstrip |> String.split(@message_separator)
  end
end
