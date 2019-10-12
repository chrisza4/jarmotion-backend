defmodule Jarmotion.Schemas.Alert do
  use Ecto.Schema
  import Ecto.Changeset
  alias Jarmotion.Schemas.{Alert, User}

  @alert_status [
    "created",
    "push_failed",
    "pending",
    "acknowledged"
  ]

  @primary_key {:id, :binary_id, autogenerate: true}
  @timestamps_opts [type: :utc_datetime]
  schema "alerts" do
    field :status, :string
    belongs_to :owner, User, foreign_key: :owner_id, type: :binary_id
    belongs_to :to_user, User, foreign_key: :to_user_id, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(%Alert{} = alert, attrs) do
    alert
    |> cast(attrs, [:id, :status, :owner_id, :to_user_id])
    |> validate_required([:status, :owner_id, :to_user_id])
    |> validate_status(:all)
  end

  @doc ~S"""
    New Alert instance from hashmap
    ## Examples

    iex> new(%{id: "alert1", status: "created", owner_id: "user1", to_user_id: "user2"})
    {:ok, %Jarmotion.Schemas.Alert{id: "alert1", inserted_at: nil, owner_id: "user1", to_user_id: "user2", status: "created", updated_at: nil}}
  """
  def new(attrs) do
    changeset = %Alert{} |> changeset(attrs) |> validate_status(:new)

    if changeset.valid? do
      {:ok, apply_changes(changeset)}
    else
      {:error, :invalid_input, changeset}
    end
  end

  defp validate_status(alert, :new), do: validate_inclusion(alert, :status, ["created"])
  defp validate_status(alert, _), do: validate_inclusion(alert, :status, @alert_status)
end
