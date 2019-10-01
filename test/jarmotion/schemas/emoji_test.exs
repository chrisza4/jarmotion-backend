defmodule Jarmotion.Schemas.EmojiTest do
  use ExUnit.Case, async: true
  alias Jarmotion.Schemas.Emoji
  doctest Jarmotion.Schemas.Emoji, import: true

  describe "Emoji Schema" do
    test "return invalid input with invalid type" do
      assert {:error, :invalid_input, _} =
               Emoji.new(%{id: "emoji1", type: "hearts", owner_id: "user1"})
    end
  end
end
