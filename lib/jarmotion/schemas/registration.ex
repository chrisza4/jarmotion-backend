defmodule Jarmotion.Schemas.Registration do
  use Ecto.Schema
  import Ecto.Changeset
  alias Jarmotion.Schemas.User

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
end
