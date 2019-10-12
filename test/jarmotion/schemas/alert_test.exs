defmodule Jarmotion.Schemas.AlertTest do
  use ExUnit.Case, async: true
  alias Jarmotion.Schemas.Alert
  doctest Jarmotion.Schemas.Alert, import: true

  test "Should not allow create alert in other status excepted :create" do
    assert {:ok, _} =
             Alert.new(%{id: "alert1", status: "created", owner_id: "user1", to_user_id: "user2"})

    assert {:error, :invalid_input, _} =
             Alert.new(%{
               id: "alert1",
               status: "acknowledged",
               owner_id: "user1",
               to_user_id: "user2"
             })
  end
end
