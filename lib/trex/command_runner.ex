defmodule Trex.CommandRunner do
  def run(:ping, storage) do
    {{:ok, "PONG"}, storage}
  end

  def run({:get, key}, storage) do
    {{:ok, "#{storage[key]}"}, storage}
  end

  def run({:set, key, value}, storage) do
    {{:ok, "OK"}, Map.put_new(storage, key, value)}
  end
end
