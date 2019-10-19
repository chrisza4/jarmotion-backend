defmodule JarmotionWeb.DeviceView do
  use JarmotionWeb, :view

  def render("device.json", %{device: device}) do
    %{
      id: device.id,
      token: device.token,
      owner_id: device.owner_id,
      inserted_at: device.inserted_at,
      updated_at: device.updated_at
    }
  end
end
