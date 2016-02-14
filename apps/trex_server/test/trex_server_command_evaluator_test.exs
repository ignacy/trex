defmodule TrexServerCommandEvaluatorTest do
  use ExUnit.Case
  doctest TrexServer.CommandEvaluator
  alias TrexServer.CommandEvaluator

  test "ping" do
    assert CommandEvaluator.evaluate(TrexServer.InMemoryAdapter, "PING\r\n") == {:ok, "PONG"}
  end

  test "unknown command" do
    assert CommandEvaluator.evaluate(TrexServer.InMemoryAdapter, "UNKNOWN_COMMAND\r\n") == {:error, :unknown_command}
  end
end
