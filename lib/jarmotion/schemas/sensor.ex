defmodule Jarmotion.Schemas.Sensor do
  use Ecto.Schema
  import Ecto.Changeset
  alias Jarmotion.Schemas.{User, Emoji, Sensor}

  @primary_key {:id, :binary_id, autogenerate: true}
  @timestamps_opts [type: :utc_datetime]
  schema "sensors" do
    belongs_to :owner, User, foreign_key: :owner_id, type: :binary_id
    field :emoji_type, :string
    field :threshold, :integer

    timestamps()
  end

  @doc false
  def changeset(sensor, attrs) do
    sensor
    |> cast(attrs, [:id, :owner_id, :emoji_type, :threshold])
    |> validate_required([:owner_id, :emoji_type, :threshold])
    |> validate_inclusion(:emoji_type, Emoji.emoji_types())
    |> validate_number(:threshold, greater_than_or_equal_to: 0)
  end

  @doc ~S"""
    New sensor instance from hashmap
    ## Examples

    iex> new(%{id: "a4683cda-de98-4714-baf3-58d393eff67d", owner_id: "user1", emoji_type: "confident", threshold: 1})
    {:ok, %Jarmotion.Schemas.Sensor{id: "a4683cda-de98-4714-baf3-58d393eff67d", inserted_at: nil, owner_id: "user1", emoji_type: "confident", threshold: 1, updated_at: nil}}
  """
  def new(attrs) do
    changeset = %Sensor{} |> changeset(attrs)

    if changeset.valid? do
      {:ok, apply_changes(changeset)}
    else
      {:error, :invalid_input, changeset}
    end
  end
end
