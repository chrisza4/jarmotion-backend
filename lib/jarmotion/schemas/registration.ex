defmodule Jarmotion.Schemas.Registration do
  use Ecto.Schema
  import Ecto.Changeset
  alias Jarmotion.Schemas.{User, Registration}
  alias Jarmotion.Utils

  @primary_key {:id, :binary_id, autogenerate: true}
  @timestamps_opts [type: :utc_datetime]
  schema "registrations" do
    belongs_to :owner, User, foreign_key: :owner_id, type: :binary_id
    field :code, :string

    timestamps()
  end

  @doc false
  def changeset(registration, attrs) do
    registration
    |> cast(attrs, [:id, :owner_id, :code])
    |> validate_required([:code])
  end

  def new(attrs) do
    changeset = %Registration{} |> changeset(attrs)

    if changeset.valid? do
      {:ok, apply_changes(changeset)}
    else
      {:error, :invalid_input, changeset}
    end
  end

  def generate_code() do
    Utils.random_string(6)
  end
end
