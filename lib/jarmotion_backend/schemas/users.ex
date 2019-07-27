defmodule JarmotionBackend.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias JarmotionBackend.Schemas.User

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :email, :string
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:id, :email])
    |> validate_required([:id, :email])
    |> unique_constraint(:email, name: :users_email_index)
    |> unique_constraint(:id, name: :users_pkey)
  end
end
