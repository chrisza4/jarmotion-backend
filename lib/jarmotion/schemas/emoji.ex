defmodule Jarmotion.Schemas.Emoji do
  use Ecto.Schema
  import Ecto.Changeset
  alias Jarmotion.Schemas.Emoji

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "emojis" do
    field :type, :string
    field :owner_id, :string
    timestamps()
  end

  @doc false
  def changeset(%Emoji{} = emoji, attrs) do
    emoji
    |> cast(attrs, [:id, :type, :owner_id])
  end
end
