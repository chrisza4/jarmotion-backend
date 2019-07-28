defmodule Jarmotion.TestSetup do
  alias Jarmotion.Schemas.User
  alias Jarmotion.Repo.UserRepo

  @sample_user %User{
    id: "59bf0ca9-9865-4a6b-963c-766866fdb6b8",
    email: "test@test.com",
    password: "hash_randomly"
  }

  def create_user(%{} = override_info \\ %{}, password \\ "testtest") do
    hashed_pass = Bcrypt.hash_pwd_salt(password)
    user = Map.put(override_info, :password, hashed_pass)
    @sample_user |> User.changeset(user) |> UserRepo.insert()
  end
end
