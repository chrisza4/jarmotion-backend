defmodule JarmotionWeb.UserControllerTest do
  use JarmotionWeb.ConnCase
  alias Jarmotion.Schemas.{User}
  alias Jarmotion.Mocks
  import Mock

  describe "GET /users/relationship" do
    test "Get all users in relationship", %{conn: conn} do
      chris = Mocks.user_chris()
      awa = Mocks.user_awa()
      chris_user_id = Mocks.user_chris().id

      with_mocks [
        {Jarmotion.Service.UserService, [],
         get_users_in_relationship: fn user_id ->
           if user_id == chris_user_id do
             {:ok, [chris, awa]}
           else
             {:error, :forbidden}
           end
         end}
      ] do
        response =
          conn
          |> authenticate(%User{id: chris_user_id, email: "chakrit.lj@gmail.com"})
          |> get(Routes.user_path(conn, :significant_one))
          |> json_response(200)

        assert length(response) == 2
        assert Enum.at(response, 0)["id"] == chris.id
        assert Enum.at(response, 1)["id"] == awa.id
      end
    end
  end

  describe "GET /users/me" do
    test "Get my", %{conn: conn} do
      chris = Mocks.user_chris()
      chris_user_id = Mocks.user_chris().id

      with_mocks [
        {Jarmotion.Service.UserService, [],
         get: fn user_id ->
           if user_id == chris_user_id do
             {:ok, chris}
           else
             {:error, :forbidden}
           end
         end}
      ] do
        response =
          conn
          |> authenticate(%User{id: chris_user_id, email: "chakrit.lj@gmail.com"})
          |> get(Routes.user_path(conn, :me))
          |> json_response(200)

        assert response["id"] == chris.id
        assert response["email"] == "chakrit.lj@gmail.com"
      end
    end
  end

  describe "POST /users/me" do
    test "Edit my profile", %{conn: conn} do
      chris = Mocks.user_chris()
      chris_user_id = Mocks.user_chris().id

      with_mocks [
        {Jarmotion.Service.UserService, [:passthrough],
         update: fn user_id, user_info ->
           if user_id == chris_user_id do
             {:ok, %{id: user_id, email: user_info.email, name: user_info.name}}
           else
             {:error, :forbidden}
           end
         end}
      ] do
        response =
          conn
          |> authenticate(%User{id: chris_user_id, email: "chakrit.lj@gmail.com"})
          |> post(
            Routes.user_path(conn, :post_me,
              email: "chakritX@gmail.com",
              name: "Chakrit"
            )
          )
          |> json_response(200)

        assert response["id"] == chris.id
        assert response["email"] == "chakritX@gmail.com"
        assert response["name"] == "Chakrit"
      end
    end
  end
end
