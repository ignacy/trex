defmodule Trex.CommandRunner do
  def run(:ping, _storage_adapter, storage) do
    {{:ok, "PONG"}, storage}
  end

  def run({:get, key}, storage_adapter, storage) do
    {{:ok, "#{storage_adapter.get(storage, key)}"}, storage}
  end

  def run({:set, key, value}, storage_adapter, storage) do
    {{:ok, "OK"}, storage_adapter.put(storage, key, value)}
  end
end
