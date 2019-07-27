defmodule JarmotionWeb.Error do
  def forbidden, do: %{error_status: "403", error_message: "unauthorized"}
end
