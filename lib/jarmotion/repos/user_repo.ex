defmodule Jarmotion.Repo.UserRepo do
  import Ecto.Query
  alias Jarmotion.Schemas.User
  alias Jarmotion.Repo.UserRepo
  alias Jarmotion.Repo

  def insert(%User{} = user), do: Repo.insert(user)
  def insert(%Ecto.Changeset{valid?: true} = user), do: Repo.insert(user)
  def get(id), do: Repo.get(User, id)
  def get_by_email(email), do: Repo.get_by(User, email: email)

  def update_by_id(user_id, updates), do: get(user_id) |> UserRepo.update(updates)

  def get_by_ids(ids) when is_list(ids) do
    from(user in User, where: user.id in ^ids, select: user) |> Repo.all()
  end

  def update(user, updates) do
    User.changeset(user, updates) |> Repo.update()
  end
end
