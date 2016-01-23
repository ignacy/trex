defmodule TrexCommandParserTest do
  use ExUnit.Case
  doctest Trex.CommandParser

  test "ping" do
    assert Trex.CommandParser.parse("PING\r\n") == {:ok, :ping}
  end

  test "unknown command" do
    assert Trex.CommandParser.parse("UNKNOWN_COMMAND\r\n") == {:error, :unknown_command}
  end
end
