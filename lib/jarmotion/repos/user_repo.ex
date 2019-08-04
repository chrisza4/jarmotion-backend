defmodule Jarmotion.Repo.UserRepo do
  alias Jarmotion.Schemas.User
  alias Jarmotion.Repo

  def insert(%User{} = user), do: Repo.insert(user)
  def insert(%Ecto.Changeset{valid?: true} = user), do: Repo.insert(user)
  def get(id), do: Repo.get(User, id)
  def get_by_email(email), do: Repo.get_by(User, email: email)
end
