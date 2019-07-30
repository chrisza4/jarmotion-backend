defmodule Jarmotion.TestSetup do
  alias Jarmotion.Schemas.User
  alias Jarmotion.Repo.UserRepo
  alias Jarmotion.Mocks

  def create_user(%{} = override_info \\ %{}, password \\ "testtest") do
    hashed_pass = Bcrypt.hash_pwd_salt(password)
    user = Map.put(override_info, :password, hashed_pass)
    Mocks.user_sample() |> User.changeset(user) |> UserRepo.insert()
  end
end
