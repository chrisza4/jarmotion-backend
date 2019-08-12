defmodule JarmotionWeb.RelationshipControllerTest do
  use JarmotionWeb.ConnCase
  alias Jarmotion.Schemas.{User}
  alias Jarmotion.Mocks
  import Mock

  describe "GET /relationships" do
    test "Get all users in relationship", %{conn: conn} do
      chris = Mocks.user_chris()
      awa = Mocks.user_awa()
      chris_user_id = Mocks.user_chris().id

      with_mocks [
        {Jarmotion.Service.RelationshipService, [],
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
          |> get(Routes.relationship_path(conn, :list))
          |> json_response(200)

        assert length(response) == 2
        assert Enum.at(response, 0)["id"] == chris.id
        assert Enum.at(response, 1)["id"] == awa.id
      end
    end
  end
end
