defmodule TrexFileStorageTest  do
  use ExUnit.Case

  test "allows using dict behaviour" do
    t = %Trex.FileStorage{f: %{a: 2}}
    assert t[:a] == 2

    result = Trex.FileStorage.put(t, :b, 4)
    assert result == %{}
  end
end
