defmodule TrexServerCommandEvaluatorTest do
  use ExUnit.Case
  doctest TrexServer.CommandEvaluator
  alias TrexServer.CommandEvaluator

  test "ping" do
    assert CommandEvaluator.evaluate("PING\r\n", Map, %{}) == {{:ok, "PONG"}, %{}}
  end

  test "unknown command" do
    assert CommandEvaluator.evaluate("UNKNOWN_COMMAND\r\n", Map, %{}) == {{:error, :unknown_command}, %{}}
  end
end
