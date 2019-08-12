defmodule Jarmotion.Service.RelationshipService do
  alias Jarmotion.Repo.{RelationshipRepo, UserRepo}

  def get_users_in_relationship(owner_id) do
    {:ok,
     RelationshipRepo.get_friend_ids(owner_id)
     |> UserRepo.get_by_ids()}
  end
end
