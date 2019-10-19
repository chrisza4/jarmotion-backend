defmodule JarmotionWeb.SensorView do
  use JarmotionWeb, :view

  def render("sensors.json", %{sensors: sensors}) do
    render_many(sensors, JarmotionWeb.SensorView, "sensor.json")
  end

  def render("sensor.json", %{sensor: sensor}) do
    %{
      id: sensor.id,
      emoji_type: sensor.emoji_type,
      threshold: sensor.threshold,
      inserted_at: sensor.inserted_at,
      updated_at: sensor.updated_at
    }
  end
end
