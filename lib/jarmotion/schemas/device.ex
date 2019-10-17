defmodule Jarmotion.Schemas.Device do
  use Ecto.Schema
  import Ecto.Changeset
  alias Jarmotion.Schemas.{Device, User}

  @primary_key {:id, :binary_id, autogenerate: true}
  @timestamps_opts [type: :utc_datetime]
  schema "devices" do
    field :token, :string
    belongs_to :owner, User, foreign_key: :owner_id, type: :binary_id
    timestamps()
  end

  @doc false
  def changeset(%Device{} = device, attrs) do
    device
    |> cast(attrs, [:id, :token, :owner_id, :inserted_at])
    |> validate_required([:token, :owner_id])
  end

  def new(attrs) do
    changeset = %Device{} |> changeset(attrs)

    if changeset.valid? do
      {:ok, apply_changes(changeset)}
    else
      {:error, :invalid_input, changeset}
    end
  end
end
