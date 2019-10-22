defmodule Jarmotion.Service.EmojiServiceTest do
  use JarmotionWeb.ConnCase, async: true
  alias Jarmotion.TestSetup
  alias Jarmotion.Service.EmojiService
  alias Jarmotion.Schemas.Emoji

  import Mock

  describe "list_today_emojis" do
    setup %{} do
      {:ok, chris} = TestSetup.create_user(%{email: "chris@test.com"}, "mypassword")
      {:ok, awa} = TestSetup.create_user(%{email: "awa@test.com"}, "mypassword")
      {:ok, randomguy} = TestSetup.create_user(%{email: "randomguy@test.com"}, "mypassword")
      {:ok, emoji_awa} = TestSetup.create_emoji(awa.id)
      {:ok, emoji_chris} = TestSetup.create_emoji(chris.id)
      {:ok, past, 0} = DateTime.from_iso8601("2015-01-23T23:50:07Z")
      TestSetup.create_emoji(chris.id, %{inserted_at: past})
      TestSetup.create_relationship(chris.id, awa.id)

      {:ok,
       chris: chris,
       awa: awa,
       randomguy: randomguy,
       emoji_awa: emoji_awa,
       emoji_chris: emoji_chris}
    end

    test "Should be able to get emojis of user in relationship", %{
      chris: chris,
      awa: awa,
      emoji_awa: emoji_awa,
      emoji_chris: emoji_chris
    } do
      {:ok, actual} = EmojiService.list_today_emojis(chris.id, awa.id)
      assert length(actual) == 1
      assert Enum.at(actual, 0).id == emoji_awa.id

      {:ok, actual2} = EmojiService.list_today_emojis(awa.id, chris.id)
      assert length(actual2) == 1
      assert Enum.at(actual2, 0).id == emoji_chris.id
    end

    test "Should be able to get own emojis", %{chris: chris, emoji_chris: emoji_chris} do
      {:ok, actual2} = EmojiService.list_today_emojis(chris.id, chris.id)
      assert length(actual2) == 1
      assert Enum.at(actual2, 0).id == emoji_chris.id
    end

    test "Should not be able to get emojis of user not in relationship", %{
      awa: awa,
      randomguy: randomguy
    } do
      assert {:error, :forbidden} = EmojiService.list_today_emojis(randomguy.id, awa.id)
    end
  end

  describe "list_emojis" do
    setup %{} do
      {:ok, chris} = TestSetup.create_user(%{email: "chris@test.com"}, "mypassword")
      {:ok, awa} = TestSetup.create_user(%{email: "awa@test.com"}, "mypassword")
      {:ok, randomguy} = TestSetup.create_user(%{email: "randomguy@test.com"}, "mypassword")
      {:ok, _} = TestSetup.create_emoji(chris.id)
      {:ok, past, 0} = DateTime.from_iso8601("2015-01-23T23:50:07Z")
      {:ok, emoji_chris} = TestSetup.create_emoji(chris.id, %{inserted_at: past})
      TestSetup.create_relationship(chris.id, awa.id)

      {:ok, chris: chris, awa: awa, randomguy: randomguy, emoji_chris: emoji_chris}
    end

    test "Should be able to get emojis of user in relationship", %{
      chris: chris,
      awa: awa,
      emoji_chris: emoji_chris
    } do
      {:ok, actual} = EmojiService.list_emojis(chris.id, chris.id, "2015-01-23")

      assert length(actual) == 1
      assert Enum.at(actual, 0).id == emoji_chris.id

      {:ok, actual} = EmojiService.list_emojis(awa.id, chris.id, "2015-01-23")
      assert length(actual) == 1
      assert Enum.at(actual, 0).id == emoji_chris.id

      {:ok, actual} = EmojiService.list_emojis(awa.id, chris.id, "2015-01-24")
      assert length(actual) == 0
    end

    test "Other user cannot get emojis", %{chris: chris, randomguy: randomguy} do
      {:error, :forbidden} = EmojiService.list_emojis(randomguy.id, chris.id, "2015-01-23")
    end
  end

  describe "get_emoji" do
    setup %{} do
      {:ok, chris} = TestSetup.create_user(%{email: "chris@test.com"}, "mypassword")
      {:ok, awa} = TestSetup.create_user(%{email: "awa@test.com"}, "mypassword")
      {:ok, randomguy} = TestSetup.create_user(%{email: "randomguy@test.com"}, "mypassword")
      {:ok, emoji_awa} = TestSetup.create_emoji(awa.id)
      {:ok, emoji_chris} = TestSetup.create_emoji(chris.id)
      {:ok, past, 0} = DateTime.from_iso8601("2015-01-23T23:50:07Z")
      TestSetup.create_emoji(chris.id, %{inserted_at: past})
      TestSetup.create_relationship(chris.id, awa.id)

      {:ok,
       chris: chris,
       awa: awa,
       randomguy: randomguy,
       emoji_awa: emoji_awa,
       emoji_chris: emoji_chris}
    end

    test "chris and awa should be able to get each other emoji", %{
      chris: chris,
      awa: awa,
      emoji_awa: emoji_awa,
      emoji_chris: emoji_chris
    } do
      {:ok, actual_emoji_chris} = EmojiService.get_emoji(chris.id, emoji_chris.id)
      assert actual_emoji_chris == emoji_chris

      {:ok, actual_emoji_chris} = EmojiService.get_emoji(awa.id, emoji_chris.id)
      assert actual_emoji_chris == emoji_chris

      {:ok, actual_emoji_awa} = EmojiService.get_emoji(awa.id, emoji_awa.id)
      assert actual_emoji_awa == emoji_awa

      {:ok, actual_emoji_awa} = EmojiService.get_emoji(chris.id, emoji_awa.id)
      assert actual_emoji_awa == emoji_awa
    end

    test "Random guy should not see awa emojis", %{
      emoji_awa: emoji_awa,
      randomguy: randomguy
    } do
      assert {:error, :forbidden} ==
               EmojiService.get_emoji(randomguy.id, emoji_awa.id)
    end

    test "Everyone cannot see non-exists emoji", %{
      chris: chris
    } do
      assert {:error, :forbidden} ==
               EmojiService.get_emoji(chris.id, Ecto.UUID.generate())
    end
  end

  describe "add_emoji" do
    setup %{} do
      {:ok, chris} = TestSetup.create_user(%{email: "chris@test.com"}, "mypassword")
      {:ok, emoji_chris} = TestSetup.create_emoji(chris.id)

      {:ok, chris: chris, emoji_chris: emoji_chris}
    end

    test "Should be able to add emoji", %{chris: chris} do
      {:ok, emoji_chris} =
        EmojiService.add_emoji(%Emoji{
          owner_id: chris.id,
          type: "heart"
        })

      {:ok, actual} = EmojiService.list_today_emojis(chris.id, chris.id)
      assert Enum.at(actual, 0).id == emoji_chris.id
    end

    test "Should broadcast emoji changes", %{chris: chris} do
      with_mocks [
        {JarmotionWeb.Endpoint, [:passthrough],
         broadcast: fn _, _, _ ->
           :ok
         end}
      ] do
        {:ok, emoji_chris} =
          EmojiService.add_emoji(%Emoji{
            owner_id: chris.id,
            type: "heart"
          })

        assert_called(
          JarmotionWeb.Endpoint.broadcast("user:#{emoji_chris.owner_id}", "emoji:add", %{
            id: emoji_chris.id
          })
        )
      end
    end
  end
end
