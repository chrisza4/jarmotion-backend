defmodule Jarmotion.Service.AlertPostService do
  alias Jarmotion.Schemas.Alert
  alias Jarmotion.Service.AlertPushService

  def post_add_alert(%Alert{} = alert) do
    Task.async(fn ->
      JarmotionWeb.Endpoint.broadcast("user:#{alert.to_user_id}", "alert:add", %{id: alert.id})
    end)

    Task.async(fn -> AlertPushService.send(alert) end)
  end
end
