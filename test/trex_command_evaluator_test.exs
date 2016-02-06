defmodule TrexCommandEvaluatorTest do
  use ExUnit.Case
  doctest Trex.CommandEvaluator

  test "ping" do
    assert Trex.CommandEvaluator.evaluate("PING\r\n", Map, %{}) == {{:ok, "PONG"}, %{}}
  end

  test "unknown command" do
    assert Trex.CommandEvaluator.evaluate("UNKNOWN_COMMAND\r\n", Map, %{}) == {{:error, :unknown_command}, %{}}
  end
end
