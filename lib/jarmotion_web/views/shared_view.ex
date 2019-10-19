defmodule JarmotionWeb.SharedView do
  use JarmotionWeb, :view

  def render("success.json", _) do
    %{ok: true}
  end
end
