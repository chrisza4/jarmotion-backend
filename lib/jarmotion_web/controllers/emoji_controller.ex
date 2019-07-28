defmodule JarmotionWeb.EmojiController do
  use JarmotionWeb, :controller

  def list(conn, _) do
    send_resp(conn, 200, "hello")
  end
end
