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
    {:ok, storage} = TrexStorage.start_link(context[:filename])

    TrexStorage.put(storage, "b", 4)
    assert TrexStorage.get(storage, "b") == 4
    assert TrexStorage.keys(storage) == ["b"]
  end
end
