defmodule Jarmotion.Service.AlertService do
  alias Jarmotion.Repo.AlertRepo
  alias Jarmotion.Schemas.Alert

  require Logger

  def add_alert(by_user_id, to_user_id) do
    with {:ok, alert} <-
           Alert.new(%{owner_id: by_user_id, to_user_id: to_user_id, status: "created"}) do
      AlertRepo.insert(alert)
    end
  end

  def get_alert(by_user_id, id) do
    case AlertRepo.get(id) do
      nil -> {:error, :not_found}
      alert -> if can_access?(by_user_id, alert), do: {:ok, alert}, else: {:error, :not_found}
    end
  end

  defp can_access?(user_id, %Alert{} = alert) do
    alert.owner_id == user_id or alert.to_user_id == user_id
  end

  # defp broadcast_emoji({:error, err}), do: {:error, err}

  # defp broadcast_emoji({:ok, emoji}) do
  #   Task.async(fn ->
  #     # This might require error handling
  #     JarmotionWeb.Endpoint.broadcast("user:#{emoji.owner_id}", "emoji:add", %{id: emoji.id})
  #   end)

  #   {:ok, emoji}
  # end

  # # Unexpected input
  # defp broadcast_emoji(a) do
  #   Logger.warn("Unexpected input in broadcast emoji. Input #{inspect(a)}")
  #   a
  # end

  # defp get_with_err(id) do
  #   case EmojiRepo.get(id) do
  #     nil -> {:error, :not_found}
  #     emoji -> {:ok, emoji}
  #   end
  # end
end
