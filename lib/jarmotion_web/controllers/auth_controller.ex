defmodule JarmotionWeb.AuthController do
  use JarmotionWeb, :controller
  alias Jarmotion.Guardian
  alias Jarmotion.Service.AuthService

  action_fallback JarmotionWeb.ErrorController

  def login(conn, _params) do
    with {:ok, user} <- AuthService.login_for_user("", ""),
         {:ok, token, _} <- Guardian.encode_and_sign(user) do
      conn |> render("jwt.json", jwt: token)
    end
  end
end
