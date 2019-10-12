defmodule JarmotionWeb.AlertView do
  use JarmotionWeb, :view

  def render("alert.json", %{alert: alert}) do
    %{
      id: alert.id,
      status: alert.status,
      owner_id: alert.owner_id,
      to_user_id: alert.to_user_id,
      inserted_at: alert.inserted_at,
      updated_at: alert.updated_at
    }
  end
end
