defmodule TrexCommandRunnerTest do
  use ExUnit.Case
  doctest Trex.CommandRunner

  test "ping" do
    assert Trex.CommandRunner.run(:ping, Map, %{}) == {{:ok, "PONG"}, %{}}
  end
end
