defmodule TrexWriteAheadLogTest  do
  use ExUnit.Case

  alias Trex.WriteAheadLog

  test "allows using dict behaviour" do
    t = WriteAheadLog.new

    #assert WriteAheadLog.get(t, :a) == nil

    result = WriteAheadLog.put(t, "b", 4)
    assert WriteAheadLog.get(t, "b") == "4"
  end
end
