defmodule Trex.CommandParser do
  def parse(line) do
    case String.split(line) do
      ["PING"] -> {:ok, :ping}
      _ -> {:error, :unknown_command}
    end
  end
end
