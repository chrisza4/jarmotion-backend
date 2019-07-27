defmodule Jarmotion.Repo.UserRepo do
  alias Jarmotion.Schemas.User
  alias Jarmotion.Repo

  def insert(%User{} = user) do
    Repo.insert(user)
  end
end
