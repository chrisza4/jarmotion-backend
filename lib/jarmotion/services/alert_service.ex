defmodule Jarmotion.Service.AlertService do
  alias Jarmotion.Repo.AlertRepo
  alias Jarmotion.Schemas.Alert
  alias Jarmotion.Service.AlertPostService

  require Logger

  def add_alert(by_user_id, to_user_id) do
    with {:ok, alert} <-
           Alert.new(%{owner_id: by_user_id, to_user_id: to_user_id, status: "created"}),
         {:ok, alert} <- AlertRepo.insert(alert) do
      AlertPostService.post_add_alert(alert)
      {:ok, alert}
    end
  end

  def get_alert(by_user_id, id) do
    case AlertRepo.get(id) do
      nil -> {:error, :not_found}
      alert -> if can_access?(by_user_id, alert), do: {:ok, alert}, else: {:error, :not_found}
    end
  end

  def list_recent_alerts(by_user_id),
    do: list_recent_alerts(by_user_id, Timex.subtract(Timex.now(), Timex.Duration.from_days(1)))

  def list_recent_alerts(by_user_id, since) do
    {:ok, AlertRepo.list_related(by_user_id, since)}
  end

  defp can_access?(user_id, %Alert{} = alert) do
    alert.owner_id == user_id or alert.to_user_id == user_id
  end
end
