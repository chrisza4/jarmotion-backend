defmodule JarmotionWeb.RelationshipController do
  use JarmotionWeb, :controller
  alias Jarmotion.Service.RelationshipService

  action_fallback JarmotionWeb.ErrorController

  def list(conn, _params) do
    with {:ok, users} <- RelationshipService.get_users_in_relationship(current_user_id(conn)) do
      conn |> render("relationship.json", %{users: users})
    end
  end
end
