defmodule Jarmotion.Utils do
  def to_keyword_list(%_{} = struct) do
    Map.from_struct(struct) |> to_keyword_list()
  end

  def to_keyword_list(%{} = map) do
    Enum.map(map, fn {key, value} -> {key, value} end)
  end

  @alphabet Enum.concat([?0..?9, ?A..?Z, ?a..?z])
  def random_string(count) do
    :rand.seed(:exsplus, :os.timestamp())

    Stream.repeatedly(&random_char_from_alphabet/0)
    |> Enum.take(count)
    |> List.to_string()
  end

  defp random_char_from_alphabet() do
    Enum.random(@alphabet)
  end
end
