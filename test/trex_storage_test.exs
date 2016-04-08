defmodule TrexStorageTest do
  use ExUnit.Case
  doctest Trex.Storage

  setup_all do
    Application.stop(:trex)
    :ok
  end

  def filename, do: "trex_test.dets"

  setup do
    on_exit fn ->
      File.rm(filename)
    end
  end

  test "k/v interface" do
    {:ok, storage} = Trex.Storage.start_link(filename)

    Trex.Storage.put(storage, "b", 4)
    assert Trex.Storage.get(storage, "b") == 4
    assert Trex.Storage.keys(storage) == ["b"]
  end

  test "cleaning up after tests using monitor" do
    {:ok, storage} = Trex.Storage.start_link(filename)

    assert :dets.info(Trex.Storage.table_name) != :undefined

    GenServer.stop(storage)

    assert :dets.info(Trex.Storage.table_name) == :undefined
  end
end
