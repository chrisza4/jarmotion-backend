defmodule Jarmotion.Service.UserServiceTest do
  use JarmotionWeb.ConnCase, async: true
  alias Jarmotion.TestSetup
  alias Jarmotion.Service.UserService
  alias Jarmotion.Schemas.Requests.UserUpdate

  describe "get_users_in_relationship" do
    setup %{} do
      {:ok, chris} = TestSetup.create_user(%{email: "chris@test.com"}, "mypassword")
      {:ok, awa} = TestSetup.create_user(%{email: "awa@test.com"}, "mypassword")
      {:ok, _} = TestSetup.create_user(%{email: "randomguy@test.com"}, "mypassword")
      TestSetup.create_relationship(chris.id, awa.id)

      {:ok, chris: chris, awa: awa}
    end

    test "Should be able to list people in relationship", %{
      chris: chris,
      awa: awa
    } do
      {:ok, list} = UserService.get_users_in_relationship(chris.id)
      assert list == [awa]

      {:ok, list} = UserService.get_users_in_relationship(awa.id)
      assert list == [chris]
    end
  end

  describe "update" do
    setup %{} do
      {:ok, chris} = TestSetup.create_user(%{email: "chris@test.com"}, "mypassword")

      {:ok, chris: chris}
    end

    test "should be able to update", %{chris: chris} do
      {:ok, update_result} =
        UserService.update(chris.id, %UserUpdate{email: "new@email.com", name: "newname"})

      assert update_result.email == "new@email.com"
      {:ok, new_chris} = UserService.get(chris.id)
      assert new_chris.email == "new@email.com"
      assert new_chris.id == chris.id
      assert new_chris.name == "newname"
    end
  end
end
