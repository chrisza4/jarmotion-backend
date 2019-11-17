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

  def update(user_id, %_{} = user_update), do: update(user_id, Map.from_struct(user_update))

  def update(user_id, %{} = user_update) do
    UserRepo.update(user_id, user_update)
  end

  def change_password(user_id, old_password, new_password) do
    user = UserRepo.get(user_id)

    if user != nil and Bcrypt.verify_pass(old_password, user.password) do
      {:ok, _} = UserRepo.update(user_id, %{password: Bcrypt.hash_pwd_salt(new_password)})
      :ok
    else
      {:error, :forbidden}
    end
  end

  def upload_avatar(user_id, %Plug.Upload{} = upload) do
  end
end
