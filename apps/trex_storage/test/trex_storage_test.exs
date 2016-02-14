defmodule TrexStorageTest do
  use ExUnit.Case
  doctest TrexStorage

  test "put, set" do
    TrexStorage.start_link

    TrexStorage.put("b", 4)
    assert TrexStorage.get("b") == 4
    assert TrexStorage.keys == ["b"]
  end
end
