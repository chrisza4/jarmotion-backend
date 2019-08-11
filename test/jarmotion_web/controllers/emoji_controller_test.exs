defmodule JarmotionWeb.EmojiControllerTest do
  use JarmotionWeb.ConnCase
  alias Jarmotion.Schemas.{User}
  alias Jarmotion.Mocks
  import Mock

  describe "GET /emoji" do
    test "Get own emoji", %{conn: conn} do
      chris_user_id = Mocks.user_chris().id
      awa_user_id = Mocks.user_awa().id

      emojis = [
        Mocks.emoji(Mocks.user_awa().id),
        Mocks.emoji(Mocks.user_awa().id)
      ]

      with_mocks [
        {Jarmotion.Service.EmojiService, [],
         get_emojis: fn user_id, by_user_id ->
           if(by_user_id == chris_user_id and user_id == awa_user_id) do
             {:ok, emojis}
           else
             {:error, :forbidden}
           end
         end}
      ] do
        %{"data" => emojis_response} =
          conn
          |> authenticate(%User{id: chris_user_id, email: "chakrit.lj@gmail.com"})
          |> get(Routes.emoji_path(conn, :list, awa_user_id))
          |> json_response(200)

        assert length(emojis_response) == 2
        assert Enum.at(emojis_response, 0)["id"] == Enum.at(emojis, 0).id
        assert Enum.at(emojis_response, 1)["id"] == Enum.at(emojis, 1).id
      end
    end

    test "Get non-friend emoji, should return error", %{conn: conn} do
      with_mocks [
        {Jarmotion.Service.EmojiService, [],
         get_emojis: fn _, _ ->
           {:error, :forbidden}
         end}
      ] do
        response =
          conn
          |> authenticate(%User{id: Mocks.user_chris().id, email: "chakrit.lj@gmail.com"})
          |> get(Routes.emoji_path(conn, :list, Mocks.user_awa().id))
          |> json_response(403)

        assert response["error_message"] == "forbidden"
      end
    end
  end

  describe "POST /emoji" do
    test "Should be able to save emoji", %{conn: conn} do
      with_mocks [
        {Jarmotion.Service.EmojiService, [],
         add_emoji: fn emoji ->
           {:ok, emoji}
         end}
      ] do
        user = Mocks.user_chris()

        emoji =
          Mocks.emoji(user.id)
          |> Map.from_struct()
          |> Map.delete(:__meta__)
          |> Map.put(:owner_id, "null")

        response =
          conn
          |> authenticate(%User{id: user.id, email: "chakrit.lj@gmail.com"})
          |> post(Routes.emoji_path(conn, :post, emoji))
          |> json_response(200)

        assert response["id"] == emoji.id
        assert response["type"] == emoji.type
        assert response["owner_id"] == user.id
      end
    end

    test "Reject invalid emoji input", %{conn: conn} do
      with_mocks [
        {Jarmotion.Service.EmojiService, [],
         add_emoji: fn emoji ->
           {:ok, emoji}
         end}
      ] do
        user = Mocks.user_chris()

        emoji =
          Mocks.emoji(user.id)
          |> Map.from_struct()
          |> Map.delete(:__meta__)
          |> Map.put(:type, "random_emoji_type")
          |> Map.put(:owner_id, "null")

        response =
          conn
          |> authenticate(%User{id: user.id, email: "chakrit.lj@gmail.com"})
          |> post(Routes.emoji_path(conn, :post, emoji))
          |> json_response(422)
      end
    end
  end
end
