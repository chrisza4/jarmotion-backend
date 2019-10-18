defmodule Jarmotion.Service.AlertPushServiceTest do
  use JarmotionWeb.ConnCase, async: true
  alias Jarmotion.TestSetup
  alias Jarmotion.Service.{AlertPushService}
  alias Jarmotion.Schemas.Alert
  alias Jarmotion.Mocks

  import Mock

  describe "Send push notification" do
    @push_response {:ok,
                    [
                      %{"status" => "ok", "id" => "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"}
                    ]}
    setup %{} do
      {:ok, chris} = TestSetup.create_user(%{email: "chris@test.com", name: "chris"})
      {:ok, awa} = TestSetup.create_user(%{email: "awa@test.com", name: "Awa"})
      {:ok, _} = TestSetup.create_device(chris.id, "mytoken")
      {:ok, awa: awa, chris: chris}
    end

    test "should send push notification", %{chris: chris, awa: awa} do
      with_mock(ExponentServerSdk.PushNotification, push_list: fn _ -> @push_response end) do
        alert = Mocks.alert_newly_created(awa.id, chris.id)
        assert :ok == AlertPushService.send(alert)

        assert_called(
          ExponentServerSdk.PushNotification.push_list([
            %{
              to: "mytoken",
              title: "Alert",
              body: "Awa just send you an alert!!!"
            }
          ])
        )
      end
    end

    @tag :skip
    test "Should update status of push notification" do
    end
  end
end
