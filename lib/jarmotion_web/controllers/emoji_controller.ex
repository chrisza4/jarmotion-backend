defmodule JarmotionWeb.EmojiController do
  use JarmotionWeb, :controller
  alias Jarmotion.Schemas.Emoji
  alias Jarmotion.Service.EmojiService

  action_fallback JarmotionWeb.ErrorController

  def list(conn, %{"id" => user_id}) do
    by_user_id = current_user_id(conn)

    with {:ok, emojis} <- EmojiService.get_emojis(user_id, by_user_id) do
      render(conn, "list.json", emojis: emojis)
    end
  end

  def post(conn, params) do
    by_user_id = current_user_id(conn)

    with {:ok, new_emoji} <- params |> Map.put("owner_id", by_user_id) |> Emoji.new(),
         {:ok, new_emoji} <- EmojiService.add_emoji(new_emoji) do
      render(conn, "emoji.json", %{emoji: new_emoji})
    end
  end
end
