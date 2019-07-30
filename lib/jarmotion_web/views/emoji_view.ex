defmodule JarmotionWeb.EmojiView do
  use JarmotionWeb, :view

  def render("list.json", %{emojis: emojis}) do
    %{
      data: render_many(emojis, JarmotionWeb.EmojiView, "emoji.json")
    }
  end

  def render("emoji.json", %{emoji: emoji}) do
    %{
      id: emoji.id,
      type: emoji.type,
      owner_id: emoji.owner_id,
      inserted_at: emoji.inserted_at
    }
  end
end
