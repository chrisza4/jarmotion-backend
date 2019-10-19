defmodule Jarmotion.Service.SensorServiceTest do
  use JarmotionWeb.ConnCase, async: true
  alias Jarmotion.TestSetup
  alias Jarmotion.Service.SensorService

  describe "upsert_sensor" do
    setup %{} do
      {:ok, chris} = TestSetup.create_user(%{email: "chris@test.com"}, "mypassword")
      {:ok, awa} = TestSetup.create_user(%{email: "awa@test.com"}, "mypassword")

      {:ok, %{chris: chris, awa: awa}}
    end

    test "Should be able to upsert sensor", %{chris: chris, awa: awa} do
      {:ok, _} = SensorService.upsert_sensor(chris.id, "confident", 3)
      {:ok, sensor1} = SensorService.upsert_sensor(chris.id, "confident", 4)
      {:ok, sensor2} = SensorService.upsert_sensor(chris.id, "love", 1)
      {:ok, sensor_awa} = SensorService.upsert_sensor(awa.id, "love", 4)

      {:ok, sensors} = SensorService.list_sensors(chris.id)
      assert length(sensors) == 2
      assert Enum.at(sensors, 0) == sensor1
      assert Enum.at(sensors, 1) == sensor2

      {:ok, sensors} = SensorService.list_sensors(awa.id)
      assert length(sensors) == 1
      assert Enum.at(sensors, 0) == sensor_awa
    end

    test "Should be able to delete sensor", %{chris: chris} do
      {:ok, _} = SensorService.upsert_sensor(chris.id, "confident", 3)
      assert :ok == SensorService.delete_sensor(chris.id, "confident")
      {:ok, sensors} = SensorService.list_sensors(chris.id)
      assert length(sensors) == 0
    end

    test "Should return error when delete not found sensor", %{chris: chris} do
      {:error, :not_found} = SensorService.delete_sensor(chris.id, "love")
    end
  end
end
