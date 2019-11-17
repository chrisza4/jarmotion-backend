defmodule Jarmotion.Utils do
  def to_keyword_list(%_{} = struct) do
    Map.from_struct(struct) |> to_keyword_list()
  end

  def to_keyword_list(%{} = map) do
    Enum.map(map, fn {key, value} -> {key, value} end)
  end
end
