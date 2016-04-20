defmodule Trex.Storage do
  use Trex.Database
  use Amnesia

  def start do
    Amnesia.Schema.create
    Amnesia.start
    Database.create
    Database.wait
  end

  def stop do
    Amnesia.stop
    Amnesia.Schema.destroy
  end

  def first do
    Amnesia.transaction do
      Translation.first()
    end
  end

  def get(key) do
    Amnesia.transaction do
      case Translation.read(key) do
        %Translation{value: v} -> {:ok, v}
        _ -> {:ok, nil}
      end
    end
  end

  def set(key, value) do
    Amnesia.transaction do
      %Translation{key: key, value: value} |> Translation.write
    end
  end

  def list_keys do
    Amnesia.transaction do
      translation = Translation.where(key != nil, select: [key])
      translation
      |>Amnesia.Selection.values
      |>List.flatten
    end
  end
end
