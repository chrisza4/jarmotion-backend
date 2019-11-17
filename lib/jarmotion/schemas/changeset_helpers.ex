defmodule Jarmotion.Schemas.ChangesetHelpers do
  import Ecto.Changeset

  def validate_uuid(changeset, field) do
    validate_change(changeset, field, fn _, uuid ->
      case Ecto.UUID.cast(uuid) do
        :error -> [{field, "#{field} must be uuid"}]
        {:ok, _} -> []
      end
    end)
  end

  def cast_and_required(struct, attrs, fields) do
    struct |> cast(attrs, fields) |> validate_required(fields)
  end
end
