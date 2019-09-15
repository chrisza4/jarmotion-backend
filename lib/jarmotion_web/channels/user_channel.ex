defmodule JarmotionWeb.UserChannel do
  use Phoenix.Channel
  alias Jarmotion.Service.UserService
  require Logger

  def join("user:" <> user_id, _, socket) do
    joiner_id = socket.assigns[:user_id]

    with :ok <- UserService.validate_in_relationship(user_id, joiner_id) do
      Logger.info("#{joiner_id} join channel of user #{user_id}")
      {:ok, socket}
    else
      {:error, :forbidden} -> {:error, %{reason: "forbidden"}}
    end
  end
end
