defmodule Jarmotion.Service.AlertPostService do
  alias Jarmotion.Schemas.Alert

  def post_add_alert(%Alert{} = alert) do
    JarmotionWeb.Endpoint.broadcast("user:#{alert.to_user_id}", "alert:add", %{id: alert.id})
  end
end
