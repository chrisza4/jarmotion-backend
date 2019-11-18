defmodule Jarmotion.Repo.RegistrationRepo do
  import Ecto.Query
  alias Jarmotion.Schemas.Registration
  alias Jarmotion.Repo

  def insert(%Registration{} = registration), do: Repo.insert(registration)
end
