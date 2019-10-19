defmodule JarmotionWeb.SensorController do
  use JarmotionWeb, :controller
  alias Jarmotion.Service.SensorService
  action_fallback(JarmotionWeb.ErrorController)

  def post(conn, %{"emoji_type" => emoji_type, "threshold" => threshold}) do
    by_user_id = current_user_id(conn)

    with {:ok, sensor} <-
           SensorService.upsert_sensor(by_user_id, emoji_type, threshold) do
      render(conn, "sensor.json", %{sensor: sensor})
    end
  end

  def post(_, _) do
    {:error, :not_found}
  end

  def list(conn, _) do
    by_user_id = current_user_id(conn)

    with {:ok, sensors} <- SensorService.list_sensors(by_user_id) do
      render(conn, "sensors.json", %{sensors: sensors})
    end
  end

  def delete(conn, %{"emoji_type" => emoji_type}) do
    by_user_id = current_user_id(conn)

    with :ok <- SensorService.delete_sensor(by_user_id, emoji_type) do
      conn
      |> put_view(JarmotionWeb.SharedView)
      |> render("success.json")
    end
  end

  def delete(_, _) do
    {:error, :not_found}
  end
end
