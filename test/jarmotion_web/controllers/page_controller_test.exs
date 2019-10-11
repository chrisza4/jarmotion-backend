defmodule JarmotionWeb.PageControllerTest do
  use JarmotionWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert response(conn, 200) =~ "Jarmotion running"
  end
end
