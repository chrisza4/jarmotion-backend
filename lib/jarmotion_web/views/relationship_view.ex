defmodule JarmotionWeb.RelationshipView do
  use JarmotionWeb, :view

  def render("relationship.json", %{users: users}) do
    render_many(users, JarmotionWeb.UserView, "user.json")
  end
end
