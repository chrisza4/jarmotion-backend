defmodule JarmotionWeb.ErrorController do
  import Plug.Conn
  use Phoenix.Controller
  alias JarmotionWeb.ErrorView

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(ErrorView)
    |> render("404.json")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(403)
    |> put_view(ErrorView)
    |> render("403.json", %{message: "unauthorized"})
  end

  def call(conn, {:error, :forbidden}) do
    conn
    |> put_status(403)
    |> put_view(ErrorView)
    |> render("403.json", %{message: "forbidden"})
  end

  def call(conn, {:error, :invalid_input, %{message: message}}) do
    conn
    |> put_status(422)
    |> put_view(ErrorView)
    |> render("422.json", %{message: message})
  end

  def call(conn, {:error, :invalid_input, changeset}) do
    conn
    |> put_status(422)
    |> put_view(ErrorView)
    |> render("422.json", %{changeset: changeset})
  end

  def call(conn, {:error}) do
    conn
    |> put_status(500)
    |> put_view(ErrorView)
    |> render("500.json", %{message: "Internal Server error"})
  end

  def auth_error(conn, _, _) do
    conn
    |> put_status(403)
    |> put_view(ErrorView)
    |> render("403.json", %{message: "forbidden"})
  end
end
