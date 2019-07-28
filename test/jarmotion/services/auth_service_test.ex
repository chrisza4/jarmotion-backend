defmodule Jarmotion.Service.AuthServiceTest do
  use JarmotionWeb.ConnCase, async: true
  alias Jarmotion.TestSetup
  alias Jarmotion.Service.AuthService

  describe "Login" do
    test "Login with correct user & password, should return success" do
      TestSetup.create_user(%{email: "testlogin@test.com"}, "mypassword")
      {:ok, user} = AuthService.login_for_user("testlogin@test.com", "mypassword")
      assert user.email === "testlogin@test.com"
    end

    test "Login with correct user but incorrect password, should return error unauthorized" do
      TestSetup.create_user(%{email: "testlogin@test.com"}, "mypassword")

      assert {:error, :unauthorized} =
               AuthService.login_for_user("testlogin@test.com", "notmypassword")
    end

    test "Login with incorrect user, should return error unauthorized" do
      assert {:error, :unauthorized} =
               AuthService.login_for_user("notexistsuser@test.com", "notmypassword")
    end
  end
end
