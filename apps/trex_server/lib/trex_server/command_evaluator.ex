defmodule TrexServer.CommandEvaluator do
  @message_separator "\t"

  def evaluate(storage_adapter, line) do
    line |> parse |> _evaluate(storage_adapter)
  end

  defp parse(line) do
    case cleanup(line) do
      [command | arguments] -> {command |> String.downcase, arguments}
    end
  end

  defp _evaluate({"ping", args}, storage) do
    {:ok, "PONG"}
  end

  defp _evaluate({"get", [key]}, storage_adapter) do
    {:ok, "#{storage_adapter.get(key)}"}
  end

  defp _evaluate({"get", _arguments}, _storage_adapter) do
    {:command_error, "Wrong number of arguments - get takes VALUE argument"}
  end

  defp _evaluate({"set", [key, value]}, storage_adapter) do
    storage_adapter.put(key, value)
    {:ok, "OK"}
  end

  defp _evaluate({"set", _arguments}, _storage_adapter) do
    {:command_error, "Wrong number of arguments - set requires KEY VALUE arguments"}
  end

  defp _evaluate({"list", []}, storage_adapter) do
    {:ok, storage_adapter.keys |> Enum.join(",")}
  end

  defp _evaluate({"list", _arguments}, _storage_adapter) do
    {:command_error, "Wrong number of arguments - list doesn't take any arguments"}
  end

  defp _evaluate({command, _arguments}, _storage) do
    {:command_error, "Unknown command: #{command}"}
  end

  defp cleanup(line) do
    line |> String.rstrip |> String.split(@message_separator)
  end
end
