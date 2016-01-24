defmodule Trex.FileStorage do
  defstruct f: %{}

  alias Trex.FileStorage

  def fetch(%FileStorage{f: f}, key) do
    Map.fetch(f, key)
  end

  # def delete(%FileStorage{f: f}, key) do
  #   Map.delete(f, key)
  # end

  def put(%FileStorage{f: f}, key, value) do
    %FileStorage{f: Map.put(f, key, value)}
  end

  # def size(%FileStorage{f: f}) do
  #   Map.size(f)
  # end
end
