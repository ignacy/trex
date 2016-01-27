defmodule Trex.CommandParser do
  def parse(line) do
    case String.split(line) do
      ["PING"] -> {:ok, :ping}
      ["GET", key] -> {:ok, {:get, key}}
      ["SET", key, value] -> {:ok, {:set, key, value}}
      ["LIST"] -> {:ok, :list}
      _ -> {:error, :unknown_command}
    end
  end
end
