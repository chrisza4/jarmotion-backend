defmodule Jarmotion.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Jarmotion.Schemas.User

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :email, :string
    field :password, :string
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:id, :email, :password])
    |> validate_required([:id, :email, :password])
    |> unique_constraint(:email, name: :users_email_index)
    |> unique_constraint(:id, name: :users_pkey)
  end
end
