defmodule Jarmotion.Repo.EmojiRepo do
  import Ecto.Query
  alias Jarmotion.Schemas.Emoji
  alias Jarmotion.Repo

  def insert(emoji), do: Repo.insert(emoji)

  def list_by_owner_id(owner_id) do
    from(e in Emoji,
      where: e.owner_id == ^owner_id,
      select: e
    )
    |> Repo.all()
  end
end
