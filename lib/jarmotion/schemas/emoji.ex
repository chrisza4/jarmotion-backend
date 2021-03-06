defmodule Jarmotion.Schemas.Emoji do
  use Ecto.Schema
  import Ecto.Changeset
  alias Jarmotion.Schemas.{Emoji, User}

  @emoji_types [
    "heart",
    "afraid",
    "amused",
    "angry",
    "anxious",
    "ashamed",
    "bashful",
    "bored",
    "cold",
    "confident",
    "confused",
    "crazy",
    "curious",
    "depressed",
    "determined",
    "enraged",
    "envious",
    "frightened",
    "happy",
    "hot",
    "indifferent",
    "jealous",
    "love",
    "miserable",
    "sad",
    "sick",
    "sorry",
    "stupid",
    "surprised",
    "suspicious",
    "withdraw"
  ]

  @primary_key {:id, :binary_id, autogenerate: true}
  @timestamps_opts [type: :utc_datetime]
  schema "emojis" do
    field :type, :string
    belongs_to :owner, User, foreign_key: :owner_id, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(%Emoji{} = emoji, attrs) do
    emoji
    |> cast(attrs, [:id, :type, :owner_id, :inserted_at])
    |> validate_required([:type, :owner_id])
    |> validate_inclusion(:type, @emoji_types)
  end

  @doc ~S"""
    New Emoji instance from hashmap
    ## Examples

    iex> new(%{id: "emoji1", type: "heart", owner_id: "user1"})
    {:ok, %Jarmotion.Schemas.Emoji{id: "emoji1", inserted_at: nil, owner_id: "user1", type: "heart", updated_at: nil}}
  """
  def new(attrs) do
    changeset = %Emoji{} |> changeset(attrs)

    if changeset.valid? do
      {:ok, apply_changes(changeset)}
    else
      {:error, :invalid_input, changeset}
    end
  end

  def emoji_types, do: @emoji_types
end
