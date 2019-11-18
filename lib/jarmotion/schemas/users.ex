defmodule Jarmotion.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Jarmotion.Schemas.{User, UserInfo}

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :email, :string
    field :password, :string
    field :name, :string
    field :photo_id, :string
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:id, :email, :password, :name, :photo_id])
    |> validate_required([:id, :email, :password, :name])
    |> unique_constraint(:email, name: :users_email_index)
    |> unique_constraint(:id, name: :users_pkey)
  end

  def new(attrs) do
    changeset =
      %User{}
      |> cast(attrs, [:id, :email, :password, :name, :photo_id])
      |> validate_required([:email, :password, :name])
      |> validate_length(:password, min: 4)
      |> unique_constraint(:email, name: :users_email_index)

    if changeset.valid? do
      {:ok, apply_changes(changeset) |> Map.put(:password, Bcrypt.hash_pwd_salt(attrs.password))}
    else
      {:error, :invalid_input, changeset}
    end
  end

  def to_user_info(%User{} = user) do
    %UserInfo{id: user.id, email: user.email}
  end
end
