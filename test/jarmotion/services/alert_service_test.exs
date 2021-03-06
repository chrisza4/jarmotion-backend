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
      {:ok, random_guy} = TestSetup.create_user(%{email: "rand@test.com"}, "mypassword")
      TestSetup.create_relationship(chris.id, awa.id)
      {:ok, awa: awa, chris: chris, random_guy: random_guy}
    end

    test "If schema correct Should be able to add alert", %{chris: chris, awa: awa} do
      assert {:ok, %Alert{} = alert} = AlertService.add_alert(chris.id, awa.id)
      assert alert.owner_id == chris.id
      assert alert.to_user_id == awa.id
      assert alert.status == "created"
    end

    test "Should not be able to add alert to people unkown to you", %{
      chris: chris,
      random_guy: random_guy
    } do
      assert({:error, :forbidden} == AlertService.add_alert(chris.id, random_guy.id))
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
      now = Timex.to_datetime({2019, 5, 5})
      yesterday = Timex.to_datetime({2019, 5, 4})
      {:ok, chris} = TestSetup.create_user(%{email: "chris@test.com"}, "mypassword")
      {:ok, awa} = TestSetup.create_user(%{email: "awa@test.com"}, "mypassword")
      {:ok, randomguy} = TestSetup.create_user(%{email: "randomguy@test.com"}, "mypassword")
      {:ok, randomgirl} = TestSetup.create_user(%{email: "randomgirl@test.com"}, "mypassword")
      {:ok, alert_awa_chris} = TestSetup.create_alert(awa.id, chris.id, now)
      {:ok, alert_chris_awa_1} = TestSetup.create_alert(chris.id, awa.id, now)
      {:ok, alert_chris_awa_2} = TestSetup.create_alert(chris.id, awa.id, now)
      {:ok, _alert_chris_awa_yesterday} = TestSetup.create_alert(chris.id, awa.id, yesterday)
      {:ok, alert_random} = TestSetup.create_alert(randomguy.id, randomgirl.id, now)

      {:ok,
       chris: chris,
       awa: awa,
       randomguy: randomguy,
       randomgirl: randomgirl,
       alert_awa_chris: alert_awa_chris,
       alert_chris_awa_1: alert_chris_awa_1,
       alert_chris_awa_2: alert_chris_awa_2,
       alert_random: alert_random,
       yesterday: yesterday}
    end

    test "should be able to get alerts I sent and I received recently", %{
      chris: chris,
      awa: awa,
      alert_awa_chris: alert_awa_chris,
      alert_chris_awa_1: alert_chris_awa_1,
      alert_chris_awa_2: alert_chris_awa_2,
      yesterday: yesterday
    } do
      assert {:ok, alerts} = AlertService.list_recent_alerts(chris.id, yesterday)
      assert length(alerts) == 3
      assert Enum.any?(alerts, &(&1.id == alert_awa_chris.id))
      assert Enum.any?(alerts, &(&1.id == alert_chris_awa_1.id))
      assert Enum.any?(alerts, &(&1.id == alert_chris_awa_2.id))

      assert {:ok, alerts} = AlertService.list_recent_alerts(awa.id, yesterday)
      assert length(alerts) == 3
      assert Enum.any?(alerts, &(&1.id == alert_awa_chris.id))
      assert Enum.any?(alerts, &(&1.id == alert_chris_awa_1.id))
      assert Enum.any?(alerts, &(&1.id == alert_chris_awa_2.id))
    end
  end

  describe "ack_alert" do
    setup %{} do
      {:ok, chris} = TestSetup.create_user(%{email: "chris@test.com"}, "mypassword")
      {:ok, awa} = TestSetup.create_user(%{email: "awa@test.com"}, "mypassword")
      {:ok, alert_awa_chris} = TestSetup.create_alert(awa.id, chris.id)

      {:ok, chris: chris, awa: awa, alert_awa_chris: alert_awa_chris}
    end

    test "Should be able to ack alert sent to me", %{
      chris: chris,
      alert_awa_chris: alert_awa_chris
    } do
      assert {:ok, alert} = AlertService.ack_alert(chris.id, alert_awa_chris.id)
      assert alert.status == "acknowledged"
    end

    test "Others should not be able to ack alert", %{awa: awa, alert_awa_chris: alert_awa_chris} do
      assert {:error, :forbidden} = AlertService.ack_alert(awa.id, alert_awa_chris.id)
    end

    # test "Should not be able to ack non-exists alert", %{awa: awa, alert_awa_chris: alert_awa_chris} do
    #   assert {:error, :not_found} = AlertService.ack_alert(awa.id, "random-id")
    # end
  end
end
