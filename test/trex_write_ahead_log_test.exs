defmodule TrexWriteAheadLogTest  do
  use ExUnit.Case

  alias Trex.WriteAheadLog

  test "put, set" do
    t = WriteAheadLog.new

    WriteAheadLog.put(t, "b", 4)
    assert WriteAheadLog.get(t, "b") == "4"
  end
end
