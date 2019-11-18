defmodule JarmotionWeb.UserController do
  use JarmotionWeb, :controller
  alias Jarmotion.Service.{UserService, RegistrationService}
  alias Jarmotion.Schemas.Requests.UserUpdate
  alias Jarmotion.Guardian

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

  def post_avatar(conn, %{"avatar" => avatar}) do
    with {:ok, user} <- UserService.upload_avatar(current_user_id(conn), avatar) do
      conn |> render("user.json", %{user: user})
    end
  end

  def get_avatar(conn, %{"id" => avatar_id}) do
    with {:ok, url} <- JarmotionWeb.Uploaders.Avatar.get_original_url(avatar_id) do
      redirect(conn, external: url)
    end
  end

  def get_thumb_avatar(conn, %{"id" => avatar_id}) do
    with {:ok, url} <- JarmotionWeb.Uploaders.Avatar.get_thumb_url(avatar_id) do
      redirect(conn, external: url)
    end
  end

  def get_thumb_avatar(_, _) do
    {:error, :invalid_input}
  end

  def post_register(conn, %{"code" => code, "user" => user}) do
    user = user |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)

    with {:ok, user} <- RegistrationService.register(code, user),
         {:ok, token, _} <-
           Guardian.encode_and_sign(user) do
      conn |> put_view(JarmotionWeb.AuthView) |> render("jwt.json", jwt: token)
    end
  end

  def post_register(_, _) do
    {:error, :invalid_input}
  end
end
