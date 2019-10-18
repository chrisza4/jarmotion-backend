defmodule Jarmotion.Service.AlertPushService do
  alias Jarmotion.Schemas.Alert
  alias Jarmotion.Repo.{DeviceRepo, UserRepo, AlertRepo}

  def send(%Alert{} = alert) do
    owner = UserRepo.get(alert.owner_id)
    devices = DeviceRepo.list_by_user_id(alert.to_user_id)

    messages =
      Enum.map(devices, fn device ->
        %{
          to: device.token,
          title: "Alert",
          body: "#{owner.name} just send you an alert!!!",
          data: %{
            type: "alert",
            id: alert.id
          }
        }
      end)

    with {:ok, _} <- ExponentServerSdk.PushNotification.push_list(messages),
         {:ok, alert} <- AlertRepo.update_status(alert, "pending") do
      {:ok, alert}
    else
      {:error, _message, _status_code} -> handle_failed_send(alert)
    end
  end

  defp handle_failed_send(%Alert{} = alert) do
    with {:ok, _} <- AlertRepo.update_status(alert, "push_failed") do
      {:error, :push_failed}
    end
  end
end
