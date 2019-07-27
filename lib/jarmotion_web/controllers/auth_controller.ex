defmodule JarmotionWeb.AuthController do
  use JarmotionWeb, :controller
  alias Jarmotion.Guardian

  def login(conn, _params) do
    with {:ok, token, _} <- Guardian.encode_and_sign(%{id: 1}) do
      conn |> render("jwt.json", jwt: token)
    end
  end
end
