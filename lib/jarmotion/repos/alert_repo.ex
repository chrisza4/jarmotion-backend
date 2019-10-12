defmodule Jarmotion.Repo.AlertRepo do
  import Ecto.Query
  alias Jarmotion.Schemas.Alert
  alias Jarmotion.Repo

  def insert(%Alert{} = alert), do: Repo.insert(alert)
  def get(id), do: Repo.get(Alert, id)

  def list_related(user_id) do
    from(alert in Alert,
      where: alert.owner_id == ^user_id or alert.to_user_id == ^user_id,
      select: alert
    )
    |> Repo.all()
  end
end
