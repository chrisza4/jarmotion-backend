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
end
