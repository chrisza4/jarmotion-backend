defmodule Jarmotion.Service.EmojiPostService do
  alias Jarmotion.Schemas.Emoji
  require Logger

  def post_add_emoji(%Emoji{} = emoji) do
    broadcast_emoji(emoji)
  end

  defp broadcast_emoji(emoji) do
    JarmotionWeb.Endpoint.broadcast("user:#{emoji.owner_id}", "emoji:add", %{id: emoji.id})
  end
end
