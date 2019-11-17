defmodule Jarmotion.Repo.UserRepo do
  import Ecto.Query
  alias Jarmotion.Schemas.User
  alias Jarmotion.Schemas.Requests.UserUpdate
  alias Jarmotion.Repo

  def insert(%User{} = user), do: Repo.insert(user)
  def insert(%Ecto.Changeset{valid?: true} = user), do: Repo.insert(user)
  def get(id), do: Repo.get(User, id)
  def get_by_email(email), do: Repo.get_by(User, email: email)

  def get_by_ids(ids) when is_list(ids) do
    from(user in User, where: user.id in ^ids, select: user) |> Repo.all()
  end

  def update(user_id, %UserUpdate{} = user_update) do
    updates = Map.from_struct(user_update)
    get(user_id) |> User.changeset(updates) |> Repo.update()
  end
end
