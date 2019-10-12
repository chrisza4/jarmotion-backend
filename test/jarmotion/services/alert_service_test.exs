defmodule Jarmotion.Service.AlertServiceTest do
  use JarmotionWeb.ConnCase, async: true
  alias Jarmotion.TestSetup
  alias Jarmotion.Service.AlertService
  alias Jarmotion.Schemas.Alert

  # import Mock

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
      {:ok, %Alert{} = alert} = AlertService.add_alert(chris.id, awa.id)
      assert alert.owner_id == chris.id
      assert alert.to_user_id == awa.id
      assert alert.status == "created"
    end
  end
end
