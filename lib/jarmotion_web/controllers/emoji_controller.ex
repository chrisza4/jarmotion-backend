defmodule JarmotionWeb.EmojiController do
  use JarmotionWeb, :controller

  alias Jarmotion.Service.EmojiService

  action_fallback JarmotionWeb.ErrorController

  def list(conn, %{"id" => user_id}) do
    by_user_id = current_user_id(conn)

    with {:ok, emojis} <- EmojiService.get_emojis(user_id, by_user_id) do
      render(conn, "list.json", emojis: emojis)
    end
  end
end
