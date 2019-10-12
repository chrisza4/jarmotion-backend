defmodule JarmotionWeb.Error do
  use Phoenix.HTML
  def forbidden(message \\ "unauthorized"), do: %{error_status: "403", error_message: message}

  def invalid_input(detail),
    do: %{error_status: "422", error_message: detail}

  def not_found, do: %{error_status: "404", error_message: "resource not found"}

  def validation_error(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &JarmotionWeb.ErrorHelpers.translate_error/1)
  end
end
