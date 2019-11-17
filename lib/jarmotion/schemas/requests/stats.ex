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

  @doc ~S"""
    Validate and return stats from map

    Example:
    iex> Jarmotion.Schemas.Requests.Stats.validate_params(%{year: 1, month: 1, user_id: "9a68e358-c106-4480-b7e9-9359f425247a"})
    {:ok,
      %Jarmotion.Schemas.Requests.Stats{
        id: nil,
        month: 1,
        user_id: "9a68e358-c106-4480-b7e9-9359f425247a",
        year: 1
      }
    }
    iex> result = Jarmotion.Schemas.Requests.Stats.validate_params(%{yearx: 1, month: 1, user_id: '9a68e358-c106-4480-b7e9-9359f425247a'})
    iex> match?({:error, :invalid_input, _}, result)
    true
  """
  def validate_params(params) do
    params_changeset = changeset(%Stats{}, params)

    if params_changeset.valid? do
      {:ok, apply_changes(params_changeset)}
    else
      {:error, :invalid_input, params_changeset}
    end
  end

  defp changeset(struct, attrs) do
    struct
    |> ChangesetHelpers.cast_and_required(attrs, [:year, :month, :user_id])
    |> ChangesetHelpers.validate_uuid(:user_id)
  end
end
