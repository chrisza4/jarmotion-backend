defmodule Jarmotion.Schemas.Relationship do
  use Ecto.Schema
  import Ecto.Changeset
  alias Jarmotion.Schemas.{Relationship, User}

  @primary_key false
  schema "relationship" do
    belongs_to :user_1, User, foreign_key: :user_id_1, type: :binary_id
    belongs_to :user_2, User, foreign_key: :user_id_2, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(%Relationship{} = relationship, attrs) do
    relationship
    |> cast(attrs, [:user_id_1, :user_id_2])
  end
end
