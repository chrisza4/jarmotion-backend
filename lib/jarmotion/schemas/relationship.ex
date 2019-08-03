defmodule Jarmotion.Schemas.Relationship do
  use Ecto.Schema
  import Ecto.Changeset
  alias Jarmotion.Schemas.{Relationship}

  @primary_key false
  schema "relationship" do
    field :user_id_1, :binary_id
    field :user_id_2, :binary_id

    timestamps()
  end

  @doc false
  def changeset(%Relationship{} = relationship, attrs) do
    relationship
    |> cast(attrs, [:user_id_1, :user_id_2])
  end
end
