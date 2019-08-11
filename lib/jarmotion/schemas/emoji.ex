defmodule Jarmotion.Schemas.Emoji do
  use Ecto.Schema
  import Ecto.Changeset
  alias Jarmotion.Schemas.Emoji

  @emoji_types ["heart"]
  @primary_key {:id, :binary_id, autogenerate: true}
  @timestamps_opts [type: :utc_datetime]
  schema "emojis" do
    field :type, :string
    field :owner_id, :binary_id
    timestamps()
  end

  @doc false
  def changeset(%Emoji{} = emoji, attrs) do
    emoji
    |> cast(attrs, [:id, :type, :owner_id, :inserted_at])
    |> validate_required([:type, :owner_id])
    |> validate_inclusion(:type, @emoji_types)
  end

  def new(attrs) do
    changeset = %Emoji{} |> changeset(attrs)

    if changeset.valid? do
      {:ok, apply_changes(changeset)}
    else
      {:error, :invalid_input, changeset}
    end
  end
end
