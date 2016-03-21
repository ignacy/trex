defmodule Trex.CommandEvaluator do
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
    case GenServer.call(:trex_storage, {:get, key}) do
      {:ok, val} -> {:ok, val}
      v -> {:ok, v}
    end
  end

  defp _evaluate({:set, key, value}) do
    GenServer.cast(:trex_storage, {:put, key, value})
    {:ok, "OK"}
  end

  defp _evaluate(:list) do
    keys = GenServer.call(:trex_storage, :keys)
    {:ok, keys |> Enum.join(",")}
  end

  defp _evaluate(error) do
    error
  end

  defp cleanup(line) do
    line |> String.rstrip |> String.split(@message_separator)
  end
end
