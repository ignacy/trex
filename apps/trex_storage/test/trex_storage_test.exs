defmodule TrexStorageTest do
  use ExUnit.Case
  doctest TrexStorage

  setup do
    filename = "trex_test.dat"

    File.touch(filename)

    on_exit fn ->
      File.rm(filename)
    end

    {:ok, filename: filename}
  end

  test "put, set", context do
    TrexStorage.start_link(context[:filename])

    TrexStorage.put("b", 4)
    assert TrexStorage.get("b") == 4
    assert TrexStorage.keys == ["b"]
  end
end
