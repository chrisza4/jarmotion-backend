defmodule JarmotionBackendWeb.PageController do
  use JarmotionBackendWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
