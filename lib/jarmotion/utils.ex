defmodule Jarmotion.Utils do
  def to_keyword_list(map = %{}) do
    Enum.map(map, fn {key, value} -> {key, value} end)
  end
end
