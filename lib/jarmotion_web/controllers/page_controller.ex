defmodule JarmotionWeb.PageController do
  use JarmotionWeb, :controller

  def index(conn, _params) do
    send_resp(conn, 200, "Jarmotion running")
  end
end
