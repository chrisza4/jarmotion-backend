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

  def count_by_type_today(owner_id) do
    begin_of_today = Timex.now("Asia/Bangkok") |> Timex.Protocol.beginning_of_day()
    end_of_today = Timex.now("Asia/Bangkok") |> Timex.Protocol.end_of_day()

    from(e in Emoji,
      where:
        e.owner_id == ^owner_id and e.inserted_at >= ^begin_of_today and
          e.inserted_at <= ^end_of_today,
      group_by: e.type,
      select: %{type: e.type, count: count(e)}
    )
    |> Repo.all()
  end

  def max_by_month(owner_id, year, month) do
    begin = Timex.to_datetime({year, month, 1}, :local)
    finish = Timex.Protocol.end_of_month(begin)

    query_count_by_type_and_date =
      from(e in Emoji,
        select: %{
          date: fragment("date_trunc('day', ?)", e.inserted_at),
          type: e.type,
          count: count(e.type)
        },
        where: e.owner_id == ^owner_id and e.inserted_at >= ^begin and e.inserted_at <= ^finish,
        group_by: [fragment("date"), e.type],
        order_by: [fragment("date")]
      )

    query_max_of_type_each_date =
      from(q in subquery(query_count_by_type_and_date),
        select: %{max: max(q.count), date: q.date},
        group_by: q.date
      )

    from(q1 in subquery(query_count_by_type_and_date),
      join: q2 in subquery(query_max_of_type_each_date),
      on: q2.max == q1.count and q2.date == q1.date,
      select: q1
    )
    |> Repo.all()

    # |> Repo.all()
  end

  def get(id), do: Repo.get(Emoji, id)
end
