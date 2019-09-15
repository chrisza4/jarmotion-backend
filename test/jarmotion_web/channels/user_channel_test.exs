defmodule JarmotionWeb.UserChannelTest do
  use JarmotionWeb.ChannelCase
  alias Jarmotion.TestSetup

  setup %{} do
    {:ok, chris} = TestSetup.create_user(%{email: "chris@test.com"}, "mypassword")
    {:ok, awa} = TestSetup.create_user(%{email: "awa@test.com"}, "mypassword")
    {:ok, randomguy} = TestSetup.create_user(%{email: "randomguy@test.com"}, "mypassword")
    TestSetup.create_relationship(chris.id, awa.id)
    {:ok, chris: chris, awa: awa, randomguy: randomguy}
  end

  test "should be able to join if user is in relationship", %{chris: chris, awa: awa} do
    assert {:ok, _, _} =
             socket(JarmotionWeb.UserSocket, "some-id", %{user_id: chris.id})
             |> subscribe_and_join(JarmotionWeb.UserChannel, "user:#{awa.id}")
  end

  test "should not be able to join if user is not in relationship", %{
    chris: chris,
    randomguy: randomguy
  } do
    assert {:error, %{reason: "forbidden"}} ==
             socket(JarmotionWeb.UserSocket, "some-id", %{user_id: randomguy.id})
             |> subscribe_and_join(JarmotionWeb.UserChannel, "user:#{chris.id}")
  end
end
