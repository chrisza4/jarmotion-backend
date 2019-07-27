defmodule Jarmotion.Repo.UserRepo do
  alias Jarmotion.Schemas.User
  alias Jarmotion.Repo

  def insert(%User{} = user), do: Repo.insert(user)
  def get(id), do: Repo.get(User, id)
end
