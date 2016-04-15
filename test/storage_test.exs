defmodule TrexStorage.Test do
  use ExUnit.Case

  setup do
    Trex.Database.destroy
    Trex.Storage.start
    Trex.Database.wait
    on_exit fn ->
      Trex.Storage.stop
      Trex.Database.destroy
    end
  end

  test "saving translation" do
    Trex.Storage.set("foo", "bar")
    assert {:ok, "bar"} == Trex.Storage.get("foo")
  end

  test "updating value" do
    Trex.Storage.set("foo", "bar")
    Trex.Storage.set("foo", "bazinga")
    assert {:ok, "bazinga"} == Trex.Storage.get("foo")
  end

  test "accessing a missing key" do
    assert {:ok, nil} == Trex.Storage.get("bazinga")
  end

  test "listing keys" do
    Trex.Storage.set("foo", "bar")
    Trex.Storage.set("else", "bazinga")
    assert ["else", "foo"] == Trex.Storage.list_keys
  end
end
