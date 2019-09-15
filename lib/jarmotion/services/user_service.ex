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

  def validate_in_relationship(user_id_1, user_id_2) do
    if user_id_1 == user_id_2 or RelationshipRepo.in_relationship?(user_id_1, user_id_2) do
      :ok
    else
      {:error, :forbidden}
    end
  end
end
