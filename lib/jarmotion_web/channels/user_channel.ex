defmodule JarmotionWeb.UserChannel do
  use Phoenix.Channel
  require Logger

  def join("user:" <> user_id, _, socket) do
    Logger.info("#{user_id} got joined")
    {:ok, socket}
  end
end
