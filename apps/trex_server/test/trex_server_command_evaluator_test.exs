defmodule TrexServerCommandEvaluatorTest do
  use ExUnit.Case
  doctest TrexServer.CommandEvaluator
  alias TrexServer.CommandEvaluator

  test "ping" do
    assert CommandEvaluator.evaluate(TrexServer.InMemoryAdapter, "PING\r\n") == {:ok, "PONG"}
  end

  test "command with wrong number of arguments" do
    assert CommandEvaluator.evaluate(TrexServer.InMemoryAdapter, "GET\t\KEY\tOPS_IVE_ADDED_AN_ARGUMENT\r\n") == \
      {:command_error, "Wrong number of arguments - get takes VALUE argument"}
    assert CommandEvaluator.evaluate(TrexServer.InMemoryAdapter, "SET\tKEY\r\n") == \
      {:command_error, "Wrong number of arguments - set requires KEY VALUE arguments"}
  end

  test "some garbage" do
    assert CommandEvaluator.evaluate(TrexServer.InMemoryAdapter, "SET\t\t\t\t\r\n") == \
      {:command_error, "Wrong number of arguments - set requires KEY VALUE arguments"}
  end

  test "unknown command" do
    assert CommandEvaluator.evaluate(TrexServer.InMemoryAdapter, "UNKNOWN_COMMAND\r\n") == \
      {:command_error, "Unknown command: unknown_command"}
  end
end
