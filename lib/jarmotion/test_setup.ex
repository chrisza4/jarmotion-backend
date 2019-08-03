defmodule Jarmotion.TestSetup do
  alias Jarmotion.Schemas.{User, Emoji, Relationship}
  alias Jarmotion.Repo.{UserRepo, EmojiRepo, RelationshipRepo}
  alias Jarmotion.Mocks

  def create_user(%{} = override_info \\ %{}, password \\ "testtest") do
    hashed_pass = Bcrypt.hash_pwd_salt(password)
    user = Map.put(override_info, :password, hashed_pass)

    Mocks.user_sample()
    |> User.changeset(user)
    |> UserRepo.insert()
  end

  def create_emoji(owner_id, %{} = override_info \\ %{}) do
    Mocks.emoji(owner_id)
    |> Emoji.changeset(override_info)
    |> EmojiRepo.insert()
  end

  def create_relationship(user_id_1, user_id_2) do
    %Relationship{user_id_1: user_id_1, user_id_2: user_id_2} |> RelationshipRepo.insert()
  end
end
