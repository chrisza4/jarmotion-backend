defmodule JarmotionWeb.Error do
  def forbidden(message \\ "unauthorized"), do: %{error_status: "403", error_message: message}
end
