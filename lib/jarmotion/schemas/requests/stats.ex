defmodule Jarmotion.Schemas.Requests.Stats do
  use Ecto.Schema
  import Ecto.Changeset
  alias Jarmotion.Schemas.Requests.Stats
  alias Jarmotion.Schemas.ChangesetHelpers

  embedded_schema do
    field :year, :integer
    field :month, :integer
    field :user_id, :binary_id
  end

  def validate_params(params) do
    params_changeset = changeset(%Stats{}, params)

    if params_changeset.valid? do
      {:ok, apply_changes(params_changeset)}
    else
      {:error, :invalid_input, params_changeset}
    end
  end

  defp changeset(struct, params) do
    struct
    |> cast(params, [:year, :month, :user_id])
    |> validate_required([:year, :month, :user_id])
    |> ChangesetHelpers.validate_uuid(:user_id)
  end
end