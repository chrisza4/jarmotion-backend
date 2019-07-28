defmodule Jarmotion.Service.AuthService do
  alias Jarmotion.Repo.UserRepo
  alias Jarmotion.Schemas.User

  def login_for_user(email, password) do
    user = UserRepo.get_by_email(email)

    if user != nil and Bcrypt.verify_pass(password, user.password) do
      {:ok, user |> User.to_user_info()}
    else
      {:error, :unauthorized}
    end
  end
end
