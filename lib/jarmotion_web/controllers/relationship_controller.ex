defmodule JarmotionWeb.RelationshipController do
  use JarmotionWeb, :controller
  # alias Jarmotion.Guardian
  # alias Jarmotion.Service.RelationshipService

  action_fallback JarmotionWeb.ErrorController

  def login(conn, _params) do
    conn |> render("relationship.json", %{users: []})
  end
end
