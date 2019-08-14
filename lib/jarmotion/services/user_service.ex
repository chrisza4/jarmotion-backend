defmodule Jarmotion.Service.UserService do
  alias Jarmotion.Repo.{RelationshipRepo, UserRepo}

  def get_users_in_relationship(owner_id) do
    {:ok,
     RelationshipRepo.get_friend_ids(owner_id)
     |> UserRepo.get_by_ids()}
  end

  def get(user_id) do
    user = UserRepo.get(user_id)

    case user do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end
end
