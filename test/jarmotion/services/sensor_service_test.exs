defmodule Jarmotion.Service.SensorServiceTest do
  use JarmotionWeb.ConnCase, async: true
  alias Jarmotion.TestSetup
  alias Jarmotion.Service.SensorService

  import Mock

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

  describe "list_trigger_sensors" do
    setup %{} do
      {:ok, chris} = TestSetup.create_user(%{email: "chris@test.com"}, "mypassword")
      {:ok, awa} = TestSetup.create_user(%{email: "awa@test.com"}, "mypassword")
      TestSetup.create_relationship(chris.id, awa.id)
      {:ok, _} = TestSetup.create_sensor(chris.id, "enraged", 2)

      {:ok, %{chris: chris, awa: awa}}
    end

    test "Given chris set too enraged to be 2, Should told chris that awa is too enraged", %{
      awa: awa,
      chris: chris
    } do
      TestSetup.create_emoji(awa.id, %{type: "enraged"})
      {:ok, users} = SensorService.list_trigger_sensors(awa.id)
      assert length(users) == 0

      TestSetup.create_emoji(awa.id, %{type: "enraged"})
      {:ok, sensors} = SensorService.list_trigger_sensors(awa.id)
      assert length(sensors) == 1
      assert Enum.at(sensors, 0).owner_id == chris.id
    end
  end

  describe "send_push_to_sensors" do
    @push_response {:ok,
                    [
                      %{"status" => "ok", "id" => "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"}
                    ]}

    setup %{} do
      {:ok, chris} = TestSetup.create_user(%{email: "chris@test.com", name: "chris"})
      {:ok, _} = TestSetup.create_device(chris.id, "mytoken1")
      {:ok, _} = TestSetup.create_device(chris.id, "mytoken2")
      {:ok, sensor} = TestSetup.create_sensor(chris.id, "enraged", 2)
      {:ok, sensor: sensor}
    end

    test "Given chris set too enraged to be 2, Should told chris that awa is too enraged", %{
      sensor: sensor
    } do
      with_mock(ExponentServerSdk.PushNotification, push_list: fn _ -> @push_response end) do
        assert :ok == SensorService.send_push_to_sensors([sensor])

        assert_called(
          ExponentServerSdk.PushNotification.push_list([
            %{
              to: "mytoken1",
              title: "Alert",
              body: "Your partner is enraged.",
              data: %{
                type: "sensor",
                id: sensor.id
              }
            },
            %{
              to: "mytoken2",
              title: "Alert",
              body: "Your partner is enraged.",
              data: %{
                type: "sensor",
                id: sensor.id
              }
            }
          ])
        )
      end
    end
  end
end
