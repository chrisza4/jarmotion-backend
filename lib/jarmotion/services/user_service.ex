defmodule Jarmotion.Service.UserService do
  alias Jarmotion.Repo.{RelationshipRepo, UserRepo}
  alias Jarmotion.Schemas.Relationship
  alias JarmotionWeb.Uploaders.Avatar

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

  def add_relationship(user_id_1, user_id_2) do
    with {:user, user1} when user1 != nil <- {:user, UserRepo.get(user_id_1)},
         {:user, user2} when user2 != nil <- {:user, UserRepo.get(user_id_2)},
         {:relationship, false} <- {:relationship, RelationshipRepo.in_relationship?(user_id_1)},
         {:relationship, false} <- {:relationship, RelationshipRepo.in_relationship?(user_id_2)} do
      RelationshipRepo.insert(%Relationship{user_id_1: user_id_1, user_id_2: user_id_2})
      {:ok, user2}
    else
      {:user, _} -> {:error, :not_found}
      {:relationship, _} -> {:error, :invalid_input}
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
    UserRepo.update_by_id(user_id, user_update)
  end

  def change_password(user_id, old_password, new_password) do
    user = UserRepo.get(user_id)

    if user != nil and Bcrypt.verify_pass(old_password, user.password) do
      {:ok, _} = UserRepo.update_by_id(user_id, %{password: Bcrypt.hash_pwd_salt(new_password)})
      :ok
    else
      {:error, :forbidden}
    end
  end

  def upload_avatar(user_id, %Plug.Upload{} = upload) do
    with {:ok, user} <- get(user_id),
         {:ok, file_id} <- generate_upload(upload) |> Avatar.store() do
      IO.inspect(file_id, label: "AAA")
      UserRepo.update(user, %{photo_id: file_id})
    end
  end

  defp generate_upload(%Plug.Upload{} = request) do
    %{
      request
      | filename: Ecto.UUID.generate() <> Path.extname(request.filename)
    }
  end
end
