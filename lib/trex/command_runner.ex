defmodule Trex.CommandRunner do
  def run(:ping) do
    {:ok, "PONG\r\n"}
  end
end
