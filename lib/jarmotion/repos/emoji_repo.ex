defmodule Jarmotion.Repo.EmojiRepo do
  import Ecto.Query
  use Timex
  alias Jarmotion.Schemas.Emoji
  alias Jarmotion.Repo

  def insert(emoji), do: Repo.insert(emoji)

  def list_by_owner_id(owner_id) do
    begin_of_today = Timex.now("Asia/Bangkok") |> Timex.Protocol.beginning_of_day()
    end_of_today = Timex.now("Asia/Bangkok") |> Timex.Protocol.end_of_day()
    list_by_owner_id(owner_id, begin_of_today, end_of_today)
  end

  def list_by_owner_id(owner_id, begin_time, end_time) do
    from(e in Emoji,
      where:
        e.owner_id == ^owner_id and e.inserted_at >= ^begin_time and
          e.inserted_at <= ^end_time,
      select: e
    )
    |> Repo.all()
  end

  def get(id), do: Repo.get(Emoji, id)
end
