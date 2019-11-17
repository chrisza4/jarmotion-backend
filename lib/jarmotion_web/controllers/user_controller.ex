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

  def change_password(conn, params) do
    user_id = current_user_id(conn)

    with :ok <-
           UserService.change_password(user_id, params["old_password"], params["new_password"]) do
      conn
      |> put_view(JarmotionWeb.SharedView)
      |> render("success.json")
    end
  end

  def post_avatar(conn, params) do
    # IO.inspect(params)
    # # Avatar.store(params["my-file"]) |> IO.inspect()
    # upload = %{
    #   params["my-file"]
    #   | filename: Ecto.UUID.generate() <> Path.extname(params["my-file"].filename)
    # }

    # JarmotionWeb.Uploaders.Avatar.store(upload) |> IO.inspect()

    conn
    |> put_view(JarmotionWeb.SharedView)
    |> render("success.json")
  end

  # def register(conn, params) do

  # end
end
