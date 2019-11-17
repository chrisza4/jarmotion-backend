defmodule Jarmotion.Service.UserServiceTest do
  use JarmotionWeb.ConnCase, async: true
  alias Jarmotion.TestSetup
  alias Jarmotion.Service.UserService

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
end
