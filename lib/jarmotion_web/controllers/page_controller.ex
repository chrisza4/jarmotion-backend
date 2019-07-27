defmodule JarmotionWeb.PageController do
  use JarmotionWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
