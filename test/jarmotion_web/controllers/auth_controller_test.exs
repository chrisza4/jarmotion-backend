defmodule JarmotionWeb.AuthControllerTest do
  use JarmotionWeb.ConnCase
  alias Jarmotion.Schemas.User
  import Mock

  describe "POST /login" do
    test "success", %{conn: conn} do
      with_mocks [
        {Jarmotion.Service.AuthService, [],
         login_for_user: fn _, _ ->
           {:ok,
            %User{
              id: "59bf0ca9-9865-4a6b-963c-766866fdb6b8",
              email: "test@test.com",
              password: "hash_randomly"
            }}
         end},
        {Jarmotion.Guardian, [], encode_and_sign: fn _ -> {:ok, "random_jwt_token", nil} end}
      ] do
        conn = post(conn, "/login")
        assert json_response(conn, 200)["jwt"] == "random_jwt_token"
      end
    end

    test "failed", %{conn: conn} do
      with_mocks [
        {Jarmotion.Service.AuthService, [],
         login_for_user: fn _, _ ->
           {:error, :unauthorized}
         end}
      ] do
        conn = post(conn, "/login")
        assert json_response(conn, 401)
      end
    end
  end
end
