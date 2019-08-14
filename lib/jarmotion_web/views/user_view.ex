defmodule JarmotionWeb.UserView do
  use JarmotionWeb, :view

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      email: user.email
    }
  end

  def render("list.json", %{users: users}) do
    render_many(users, JarmotionWeb.UserView, "user.json")
  end
end
