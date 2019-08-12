defmodule Jarmotion.Repo.RelationshipRepo do
  import Ecto.Query
  alias Jarmotion.Schemas.Relationship
  alias Jarmotion.Repo

  def insert(%Relationship{} = relationship), do: Repo.insert(relationship)
  def insert(%Ecto.Changeset{valid?: true} = relationship), do: Repo.insert(relationship)

  def is_friend(user_id_1, user_id_2) do
    from(relationship in Relationship,
      where:
        (relationship.user_id_1 == ^user_id_1 and relationship.user_id_2 == ^user_id_2) or
          (relationship.user_id_2 == ^user_id_1 and relationship.user_id_1 == ^user_id_2),
      select: relationship
    )
    |> Repo.exists?()
  end

  def get_friend_ids(user_id) do
    friend_1 =
      from(relationship in Relationship,
        where: relationship.user_id_1 == ^user_id,
        select: relationship.user_id_2
      )
      |> Repo.all()

    friend_2 =
      from(relationship in Relationship,
        where: relationship.user_id_2 == ^user_id,
        select: relationship.user_id_1
      )
      |> Repo.all()

    friend_1 ++ friend_2
  end
end
