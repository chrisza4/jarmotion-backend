defmodule Jarmotion.Service.RegistrationServiceTest do
  use JarmotionWeb.ConnCase, async: true
  alias Jarmotion.Service.{AuthService, RegistrationService}

  @user_info %{
    email: "test@test.com",
    password: "hash_randomly",
    name: "sample"
  }

  describe "generate" do
    test "Should generate registration code" do
      {:ok, registration} = RegistrationService.generate()
      {:ok, user} = RegistrationService.register(registration.code, @user_info)
      assert user.email == "test@test.com"
      assert {:ok, _} = AuthService.login_for_user("test@test.com", "hash_randomly")
    end

    test "Should not be able to duplicate registration" do
      {:ok, registration} = RegistrationService.generate()
      assert {:ok, _} = RegistrationService.register(registration.code, @user_info)
      assert {:error, :forbidden} == RegistrationService.register(registration.code, @user_info)
    end

    test "Should not be able to register with duplicate email" do
      {:ok, registration1} = RegistrationService.generate()
      {:ok, registration2} = RegistrationService.generate()
      assert {:ok, _} = RegistrationService.register(registration1.code, @user_info)
      assert {:error, :duplicate} = RegistrationService.register(registration2.code, @user_info)
    end
  end
end
