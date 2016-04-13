defmodule Trex.CommandEvaluator do
  alias Trex.{Storage}

  @message_separator "\t"

  def evaluate(line) do
    line |> parse |> _evaluate
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

  defp _evaluate(:ping) do
    {:ok, "PONG"}
  end

  defp _evaluate({:get, key}) do
    Storage.get(key)
  end

  defp _evaluate({:set, key, value}) do
    Storage.set(key, value)
    {:ok, "OK"}
  end

  defp _evaluate(:list) do
    keys = Storage.list_keys
    {:ok, keys |> Enum.join(",")}
  end

  defp _evaluate(error) do
    error
  end

  defp cleanup(line) do
    line |> String.rstrip |> String.split(@message_separator)
  end
end
