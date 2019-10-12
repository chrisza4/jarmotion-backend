defmodule Jarmotion.Service.AlertServiceTest do
  use JarmotionWeb.ConnCase, async: true
  alias Jarmotion.TestSetup
  alias Jarmotion.Service.AlertService
  # alias Jarmotion.Schemas.Alert

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

  # describe "get_emoji" do
  #   setup %{} do
  #     {:ok, chris} = TestSetup.create_user(%{email: "chris@test.com"}, "mypassword")
  #     {:ok, awa} = TestSetup.create_user(%{email: "awa@test.com"}, "mypassword")
  #     {:ok, randomguy} = TestSetup.create_user(%{email: "randomguy@test.com"}, "mypassword")
  #     {:ok, emoji_awa} = TestSetup.create_emoji(awa.id)
  #     {:ok, emoji_chris} = TestSetup.create_emoji(chris.id)
  #     {:ok, past, 0} = DateTime.from_iso8601("2015-01-23T23:50:07Z")
  #     TestSetup.create_emoji(chris.id, %{inserted_at: past})
  #     TestSetup.create_relationship(chris.id, awa.id)

  #     {:ok,
  #      chris: chris,
  #      awa: awa,
  #      randomguy: randomguy,
  #      emoji_awa: emoji_awa,
  #      emoji_chris: emoji_chris}
  #   end

  #   test "chris and awa should be able to get each other emoji", %{
  #     chris: chris,
  #     awa: awa,
  #     emoji_awa: emoji_awa,
  #     emoji_chris: emoji_chris
  #   } do
  #     {:ok, actual_emoji_chris} = EmojiService.get_emoji(chris.id, emoji_chris.id)
  #     assert actual_emoji_chris == emoji_chris

  #     {:ok, actual_emoji_chris} = EmojiService.get_emoji(awa.id, emoji_chris.id)
  #     assert actual_emoji_chris == emoji_chris

  #     {:ok, actual_emoji_awa} = EmojiService.get_emoji(awa.id, emoji_awa.id)
  #     assert actual_emoji_awa == emoji_awa

  #     {:ok, actual_emoji_awa} = EmojiService.get_emoji(chris.id, emoji_awa.id)
  #     assert actual_emoji_awa == emoji_awa
  #   end

  #   test "Random guy should not see awa emojis", %{
  #     emoji_awa: emoji_awa,
  #     randomguy: randomguy
  #   } do
  #     assert {:error, :forbidden} ==
  #              EmojiService.get_emoji(randomguy.id, emoji_awa.id)
  #   end

  #   test "Everyone cannot see non-exists emoji", %{
  #     chris: chris
  #   } do
  #     assert {:error, :forbidden} ==
  #              EmojiService.get_emoji(chris.id, Ecto.UUID.generate())
  #   end
  # end

  # describe "add_emoji" do
  #   setup %{} do
  #     {:ok, chris} = TestSetup.create_user(%{email: "chris@test.com"}, "mypassword")
  #     {:ok, emoji_chris} = TestSetup.create_emoji(chris.id)

  #     {:ok, chris: chris, emoji_chris: emoji_chris}
  #   end

  #   test "Should be able to add emoji", %{chris: chris} do
  #     {:ok, emoji_chris} =
  #       EmojiService.add_emoji(%Emoji{
  #         owner_id: chris.id,
  #         type: "heart"
  #       })

  #     {:ok, actual} = EmojiService.get_emojis(chris.id, chris.id)
  #     assert Enum.at(actual, 0).id == emoji_chris.id
  #   end

  #   test "Should broadcast emoji changes", %{chris: chris} do
  #     with_mocks [
  #       {JarmotionWeb.Endpoint, [:passthrough],
  #        broadcast: fn _, _, _ ->
  #          :ok
  #        end}
  #     ] do
  #       {:ok, emoji_chris} =
  #         EmojiService.add_emoji(%Emoji{
  #           owner_id: chris.id,
  #           type: "heart"
  #         })

  #       assert_called(
  #         JarmotionWeb.Endpoint.broadcast("user:#{emoji_chris.owner_id}", "emoji:add", %{
  #           id: emoji_chris.id
  #         })
  #       )
  #     end
  #   end
end
