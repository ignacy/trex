defmodule TrexCommandRunnerTest do
  use ExUnit.Case
  doctest Trex.CommandRunner

  test "ping" do
    assert Trex.CommandRunner.run(:ping) == {:ok, "PONG\r\n"}
  end
end
