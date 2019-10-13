defmodule JarmotionWeb.AlertController do
  use JarmotionWeb, :controller
  alias Jarmotion.Service.AlertService

  action_fallback JarmotionWeb.ErrorController

  def get(conn, %{"id" => alert_id}) do
    by_user_id = current_user_id(conn)

    with {:ok, alert} <- AlertService.get_alert(by_user_id, alert_id) do
      render(conn, "alert.json", %{alert: alert})
    end
  end

  def list_recent(conn, _params) do
    by_user_id = current_user_id(conn)

    with {:ok, alerts} <- AlertService.list_recent_alerts(by_user_id) do
      render(conn, "alerts.json", %{alerts: alerts})
    end
  end

  def post(conn, %{"to_user_id" => to_user_id}) do
    by_user_id = current_user_id(conn)

    with {:ok, new_alert} <- AlertService.add_alert(by_user_id, to_user_id) do
      render(conn, "alert.json", %{alert: new_alert})
    end
  end

  def post(_conn, _) do
    {:error, :not_found}
  end
end
