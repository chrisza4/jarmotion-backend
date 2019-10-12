defmodule Jarmotion.Service.AlertServiceTest do
  use JarmotionWeb.ConnCase, async: true
  alias Jarmotion.TestSetup
  alias Jarmotion.Service.{AlertService, AlertPostService}
  alias Jarmotion.Schemas.Alert

  import Mock

  describe "get_alert" do
    setup %{} do
      {:ok, chris} = TestSetup.create_user(%{email: "chris@test.com"}, "mypassword")
      {:ok, awa} = TestSetup.create_user(%{email: "awa@test.com"}, "mypassword")
      {:ok, randomguy} = TestSetup.create_user(%{email: "randomguy@test.com"}, "mypassword")
      {:ok, randomgirl} = TestSetup.create_user(%{email: "randomgirl@test.com"}, "mypassword")
      {:ok, alert_awa_chris} = TestSetup.create_alert(awa.id, chris.id)
      {:ok, alert_random} = TestSetup.create_alert(randomguy.id, randomgirl.id)

      {:ok,
       chris: chris,
       awa: awa,
       randomguy: randomguy,
       randomgirl: randomgirl,
       alert_awa_chris: alert_awa_chris,
       alert_random: alert_random}
    end

    test "Should be able to get alert send to me", %{
      chris: chris,
      alert_awa_chris: alert_awa_chris
    } do
      assert {:ok, alert} = AlertService.get_alert(chris.id, alert_awa_chris.id)
      assert alert.id == alert_awa_chris.id
    end

    test "Should be able to get alert created by me", %{
      awa: awa,
      alert_awa_chris: alert_awa_chris
    } do
      assert {:ok, alert} = AlertService.get_alert(awa.id, alert_awa_chris.id)
      assert alert.id == alert_awa_chris.id
    end

    test "Should not be able to get alerts of others", %{
      randomguy: randomguy,
      alert_awa_chris: alert_awa_chris
    } do
      assert {:error, :not_found} == AlertService.get_alert(randomguy.id, alert_awa_chris.id)
    end
  end

  describe "Add alert" do
    setup %{} do
      {:ok, chris} = TestSetup.create_user(%{email: "chris@test.com"}, "mypassword")
      {:ok, awa} = TestSetup.create_user(%{email: "awa@test.com"}, "mypassword")
      {:ok, awa: awa, chris: chris}
    end

    test "If schema correct Should be able to add alert", %{chris: chris, awa: awa} do
      assert {:ok, %Alert{} = alert} = AlertService.add_alert(chris.id, awa.id)
      assert alert.owner_id == chris.id
      assert alert.to_user_id == awa.id
      assert alert.status == "created"
    end

    test "Should trigger post_alert", %{chris: chris, awa: awa} do
      with_mock(AlertPostService, post_add_alert: fn _ -> :ok end) do
        {:ok, alert} = AlertService.add_alert(chris.id, awa.id)
        assert_called(AlertPostService.post_add_alert(alert))
      end
    end
  end

  describe "list_recent_alerts" do
    setup %{} do
      {:ok, chris} = TestSetup.create_user(%{email: "chris@test.com"}, "mypassword")
      {:ok, awa} = TestSetup.create_user(%{email: "awa@test.com"}, "mypassword")
      {:ok, randomguy} = TestSetup.create_user(%{email: "randomguy@test.com"}, "mypassword")
      {:ok, randomgirl} = TestSetup.create_user(%{email: "randomgirl@test.com"}, "mypassword")
      {:ok, alert_awa_chris} = TestSetup.create_alert(awa.id, chris.id)
      {:ok, alert_chris_awa_1} = TestSetup.create_alert(chris.id, awa.id)
      {:ok, alert_chris_awa_2} = TestSetup.create_alert(chris.id, awa.id)
      {:ok, alert_random} = TestSetup.create_alert(randomguy.id, randomgirl.id)

      {:ok,
       chris: chris,
       awa: awa,
       randomguy: randomguy,
       randomgirl: randomgirl,
       alert_awa_chris: alert_awa_chris,
       alert_chris_awa_1: alert_chris_awa_1,
       alert_chris_awa_2: alert_chris_awa_2,
       alert_random: alert_random}
    end

    test "should be able to get alerts I sent and I received recently", %{
      chris: chris,
      awa: awa,
      alert_awa_chris: alert_awa_chris,
      alert_chris_awa_1: alert_chris_awa_1,
      alert_chris_awa_2: alert_chris_awa_2
    } do
      assert {:ok, alerts} = AlertService.list_recent_alerts(chris.id)
      assert length(alerts) == 3
      assert Enum.any?(alerts, &(&1.id == alert_awa_chris.id))
      assert Enum.any?(alerts, &(&1.id == alert_chris_awa_1.id))
      assert Enum.any?(alerts, &(&1.id == alert_chris_awa_2.id))

      assert {:ok, alerts} = AlertService.list_recent_alerts(awa.id)
      assert length(alerts) == 3
      assert Enum.any?(alerts, &(&1.id == alert_awa_chris.id))
      assert Enum.any?(alerts, &(&1.id == alert_chris_awa_1.id))
      assert Enum.any?(alerts, &(&1.id == alert_chris_awa_2.id))
    end
  end
end
