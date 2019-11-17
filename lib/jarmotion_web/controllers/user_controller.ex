defmodule JarmotionWeb.UserController do
  use JarmotionWeb, :controller
  alias Jarmotion.Service.UserService
  alias Jarmotion.Schemas.Requests.UserUpdate

  action_fallback JarmotionWeb.ErrorController

  def significant_one(conn, _params) do
    with {:ok, users} <- UserService.get_users_in_relationship(current_user_id(conn)) do
      conn |> render("list.json", %{users: users})
    end
  end

  def me(conn, _params) do
    with {:ok, user} <- UserService.get(current_user_id(conn)) do
      conn |> render("user.json", %{user: user})
    end
  end

  def post_me(conn, params) do
    with {:ok, user_update} <- UserUpdate.validate_params(params),
         {:ok, user} <- UserService.update(current_user_id(conn), user_update) do
      conn |> render("user.json", %{user: user})
    end
  end
end
