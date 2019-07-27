defmodule JarmotionWeb.ErrorController do
  use Phoenix.Controller
  alias JarmotionWeb.ErrorView

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(403)
    |> put_view(ErrorView)
    |> render("403.json", %{message: "unauthorized"})
  end
end
