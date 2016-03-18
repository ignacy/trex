defmodule TrexStorageTest do
  use ExUnit.Case
  doctest Trex.Storage

  setup do
    Application.stop(:trex)
    filename = "trex_test.dat"

    File.touch(filename)

    on_exit fn ->
      File.rm(filename)
    end

    {:ok, filename: filename}
  end

  test "put, set", context do
    {:ok, storage} = Trex.Storage.start_link(context[:filename])

    Trex.Storage.put(storage, "b", 4)
    assert Trex.Storage.get(storage, "b") == 4
    assert Trex.Storage.keys(storage) == ["b"]
  end
end
