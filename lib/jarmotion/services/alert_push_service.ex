defmodule Jarmotion.Service.AlertPushService do
  alias Jarmotion.Schemas.Alert
  alias Jarmotion.Repo.{DeviceRepo, UserRepo}

  def send(%Alert{} = alert) do
    owner = UserRepo.get(alert.owner_id)
    devices = DeviceRepo.list_by_user_id(alert.to_user_id)

    Enum.map(devices, fn device ->
      %{
        to: device.token,
        title: "Alert",
        body: "#{owner.name} just send you an alert!!!"
      }
    end)
    |> ExponentServerSdk.PushNotification.push_list()

    :ok
  end
end
