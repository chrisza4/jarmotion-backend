defmodule Jarmotion.Service.DeviceServiceTest do
  use JarmotionWeb.ConnCase, async: true
  alias Jarmotion.TestSetup
  alias Jarmotion.Service.{DeviceService}

  describe "regis_device" do
    setup %{} do
      {:ok, chris} = TestSetup.create_user(%{email: "chris@test.com"}, "mypassword")

      {:ok, chris: chris}
    end

    test "Should be able register device", %{
      chris: chris
    } do
      assert {:ok, _} = DeviceService.regis_device(chris.id, "token1")
      # Try duplicate device
      assert {:ok, device1} = DeviceService.regis_device(chris.id, "token1")
      assert {:ok, device2} = DeviceService.regis_device(chris.id, "token2")
      assert {:ok, devices_chris} = DeviceService.list_devices(chris.id)

      assert length(devices_chris) == 1
      assert Enum.at(devices_chris, 0).id == device2.id
      assert Enum.at(devices_chris, 0).token == "token2"
    end

    test "Error forbidden when user not exists" do
      assert {:error, :forbidden} = DeviceService.regis_device(Ecto.UUID.generate(), "token1")
    end
  end

  describe "revoke_device" do
    setup %{} do
      {:ok, chris} = TestSetup.create_user(%{email: "chris@test.com"}, "mypassword")
      {:ok, device1} = TestSetup.create_device(chris.id, "token1")
      {:ok, chris: chris, device1: device1}
    end

    test "Should be able revoke device", %{
      chris: chris
    } do
      assert :ok = DeviceService.revoke_device(chris.id, "token1")
      assert {:ok, devices_chris} = DeviceService.list_devices(chris.id)
      assert length(devices_chris) == 0
    end
  end
end
