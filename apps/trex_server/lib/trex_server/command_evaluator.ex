defmodule TrexServer.CommandEvaluator do
  @message_separator "\t"

  def evaluate(storage_adapter, line) do
    line |> parse |> _evaluate(storage_adapter)
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

  defp _evaluate(:ping, _) do
    {:ok, "PONG"}
  end

  defp _evaluate({:get, key}, storage_adapter) do
    {:ok, "#{storage_adapter.get(key)}"}
  end

  defp _evaluate({:set, key, value}, storage_adapter) do
    storage_adapter.put(key, value)
    {:ok, "OK"}
  end

  defp _evaluate(:list, storage_adapter) do
    {:ok, storage_adapter.keys |> Enum.join(",")}
  end

  defp _evaluate(error, _storage) do
    error
  end

  defp cleanup(line) do
    line |> String.rstrip |> String.split(@message_separator)
  end
end
