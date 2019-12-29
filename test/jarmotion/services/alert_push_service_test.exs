defmodule Jarmotion.Service.AlertPushServiceTest do
  use JarmotionWeb.ConnCase, async: true
  alias Jarmotion.TestSetup
  alias Jarmotion.Service.{AlertPushService}
  alias Jarmotion.Repo.AlertRepo

  import Mock

  describe "Send push notification" do
    @push_response {:ok,
                    [
                      %{"status" => "ok", "id" => "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"}
                    ]}
    @push_failed_response {:error, "something", 500}

    setup %{} do
      {:ok, chris} = TestSetup.create_user(%{email: "chris@test.com", name: "chris"})
      {:ok, awa} = TestSetup.create_user(%{email: "awa@test.com", name: "Awa"})
      {:ok, alert} = TestSetup.create_alert(awa.id, chris.id)
      {:ok, _} = TestSetup.create_device(chris.id, "mytoken")
      {:ok, awa: awa, chris: chris, alert: alert}
    end

    test "should send push notification and once success, update alert status to sent", %{
      alert: alert
    } do
      with_mock(ExponentServerSdk.PushNotification, push_list: fn _ -> @push_response end) do
        assert {:ok, updated_alert} = AlertPushService.send(alert)

        assert_called(
          ExponentServerSdk.PushNotification.push_list([
            %{
              to: "mytoken",
              title: "Alert",
              body: "Awa just send you an alert!!!",
              data: %{
                type: "alert",
                id: alert.id
              },
              sound: "default"
            }
          ])
        )

        assert updated_alert.status == "pending"
      end
    end

    test "should send push notification and once failed, update alert status to failed", %{
      alert: alert
    } do
      with_mock(ExponentServerSdk.PushNotification, push_list: fn _ -> @push_failed_response end) do
        assert {:error, :push_failed} = AlertPushService.send(alert)

        assert_called(
          ExponentServerSdk.PushNotification.push_list([
            %{
              to: "mytoken",
              title: "Alert",
              body: "Awa just send you an alert!!!"
            }
          ])
        )

        updated_alert = AlertRepo.get(alert.id)
        assert updated_alert.status == "push_failed"
      end
    end
  end
end
