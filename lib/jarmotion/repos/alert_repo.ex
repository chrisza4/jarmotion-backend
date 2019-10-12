defmodule Jarmotion.Repo.AlertRepo do
  import Ecto.Query
  alias Jarmotion.Schemas.Alert
  alias Jarmotion.Repo

  def insert(%Alert{} = alert), do: Repo.insert(alert)
  def get(id), do: Repo.get(Alert, id)
end
