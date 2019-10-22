defmodule JarmotionWeb.EmojiController do
  use JarmotionWeb, :controller
  alias Jarmotion.Schemas.Emoji
  alias Jarmotion.Service.EmojiService

  action_fallback JarmotionWeb.ErrorController

  def get(conn, %{"id" => emoji_id}) do
    by_user_id = current_user_id(conn)

    with {:ok, emoji} <- EmojiService.get_emoji(by_user_id, emoji_id) do
      render(conn, "emoji.json", %{emoji: emoji})
    end
  end

  def list(conn, %{"id" => user_id, "date" => date_string}) do
    by_user_id = current_user_id(conn)

    case Timex.parse(date_string, "{YYYY}-{0M}-{0D}") do
      {:ok, date} ->
        with {:ok, emojis} <- EmojiService.list_emojis(by_user_id, user_id, date) do
          render(conn, "list.json", emojis: emojis)
        end

      {:error, _} ->
        {:error, :invalid_input, %{message: "Invalid date input"}}
    end
  end

  def list(conn, %{"id" => user_id}) do
    by_user_id = current_user_id(conn)

    with {:ok, emojis} <- EmojiService.list_today_emojis(by_user_id, user_id) do
      render(conn, "list.json", emojis: emojis)
    end
  end

  def list_owner(conn, _) do
    by_user_id = current_user_id(conn)

    with {:ok, emojis} <- EmojiService.list_today_emojis(by_user_id, by_user_id) do
      render(conn, "list.json", emojis: emojis)
    end
  end

  def post(conn, params) do
    by_user_id = current_user_id(conn)

    with {:ok, new_emoji} <- params |> Map.put("owner_id", by_user_id) |> Emoji.new(),
         {:ok, new_emoji} <-
           EmojiService.add_emoji(new_emoji) do
      render(conn, "emoji.json", %{emoji: new_emoji})
    end
  end
end
