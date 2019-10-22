defmodule JarmotionWeb.EmojiView do
  use JarmotionWeb, :view

  def render("list.json", %{emojis: emojis}) do
    render_many(emojis, JarmotionWeb.EmojiView, "emoji.json")
  end

  def render("emoji.json", %{emoji: emoji}) do
    %{
      id: emoji.id,
      type: emoji.type,
      owner_id: emoji.owner_id,
      inserted_at: emoji.inserted_at
    }
  end

  def render("stat.json", %{stat: stat}) do
    %{
      type: stat.type,
      date: stat.date,
      count: stat.count
    }
  end

  def render("stats.json", %{stats: stats}) do
    render_many(stats, JarmotionWeb.EmojiView, "stat.json", as: :stat)
  end
end
