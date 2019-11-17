defmodule Jarmotion.Schemas.Requests.UserUpdate do
  use Ecto.Schema
  import Ecto.Changeset
  alias Jarmotion.Schemas.Requests.UserUpdate
  alias Jarmotion.Schemas.ChangesetHelpers

  embedded_schema do
    field :email, :string
    field :name, :string
  end

  @doc ~S"""
    Validate and user update information from map

    Example:
    iex> Jarmotion.Schemas.Requests.UserUpdate.validate_params(%{email: "chakrit@m", name: "chris"})
    {:ok,
      %Jarmotion.Schemas.Requests.UserUpdate{
        email: "chakrit@m", name: "chris"
      }
    }
    iex> result = Jarmotion.Schemas.Requests.UserUpdate.validate_params(%{emamm: "aaa", name: "bbb" })
    iex> match?({:error, :invalid_input, _}, result)
    true
  """
  def validate_params(params) do
    params_changeset = changeset(%UserUpdate{}, params)

    if params_changeset.valid? do
      {:ok, apply_changes(params_changeset)}
    else
      {:error, :invalid_input, params_changeset}
    end
  end

  defp changeset(struct, params) do
    struct
    |> ChangesetHelpers.cast_and_required(params, [:email, :name])
  end
end
