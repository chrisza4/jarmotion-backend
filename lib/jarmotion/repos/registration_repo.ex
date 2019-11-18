defmodule Jarmotion.Repo.RegistrationRepo do
  import Ecto.Query
  alias Jarmotion.Schemas.Registration
  alias Jarmotion.Repo

  def insert(%Registration{} = registration), do: Repo.insert(registration)

  def find_unregister_code(code) do
    query =
      from r in Registration,
        where: r.code == ^code and is_nil(r.owner_id)

    Repo.get_by(query, [])
  end

  def register_for_user_id(%Registration{} = registration, user_id) do
    registration |> Registration.changeset(%{owner_id: user_id}) |> Repo.update()
  end
end
