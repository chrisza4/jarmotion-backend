defmodule JarmotionWeb.AuthController do
  use JarmotionWeb, :controller
  alias Jarmotion.Guardian
  alias Jarmotion.Service.AuthService

  action_fallback JarmotionWeb.ErrorController

  def login(conn, params) do
    with {:ok, user} <- AuthService.login_for_user(params["email"], params["password"]),
         {:ok, token, _} <- Guardian.encode_and_sign(user) do
      conn |> render("jwt.json", jwt: token)
    end
  end

  def test(conn, _) do
    send_resp(conn, 200, "Test pass")
  end
end
