defmodule JarmotionWeb.EmojiControllerTest do
  use JarmotionWeb.ConnCase
  alias Jarmotion.Schemas.{User}
  alias Jarmotion.Mocks
  alias Jarmotion.Utils
  use Timex
  import Mock

  describe "GET /emoji" do
    test "Get emoji return emoji with 200 when user allow to get emoji", %{conn: conn} do
      chris_user_id = Mocks.user_chris().id
      emoji = Mocks.emoji(Mocks.user_chris().id)

      with_mocks [
        {Jarmotion.Service.EmojiService, [],
         get_emoji: fn _, _ ->
           {:ok, emoji}
         end}
      ] do
        emojis_response =
          build_conn()
          |> authenticate(%User{id: chris_user_id, email: "chakrit.lj@gmail.com"})
          |> get(Routes.emoji_path(conn, :get, emoji.id))
          |> json_response(200)

        assert emojis_response["id"] == emoji.id
      end
    end

    test "Get emoji return emoji with 403 when user is not allowed to get emoji", %{conn: conn} do
      chris_user_id = Mocks.user_chris().id

      with_mocks [
        {Jarmotion.Service.EmojiService, [],
         get_emoji: fn _, _ ->
           {:error, :forbidden}
         end}
      ] do
        response =
          conn
          |> authenticate(%User{id: chris_user_id, email: "chakrit.lj@gmail.com"})
          |> get(Routes.emoji_path(conn, :get, "some-unavailable-emoji-id"))
          |> json_response(403)

        assert response["error_message"] == "forbidden"
      end
    end
  end

  describe "GET /emoji/user" do
    test "Get related people emoji by /emoji/:id", %{conn: conn} do
      chris_user_id = Mocks.user_chris().id
      awa_user_id = Mocks.user_awa().id

      emojis = [
        Mocks.emoji(Mocks.user_awa().id),
        Mocks.emoji(Mocks.user_awa().id)
      ]

      with_mocks [
        {Jarmotion.Service.EmojiService, [],
         list_today_emojis: fn by_user_id, user_id ->
           if(by_user_id == chris_user_id and user_id == awa_user_id) do
             {:ok, emojis}
           else
             {:error, :forbidden}
           end
         end}
      ] do
        emojis_response =
          conn
          |> authenticate(%User{id: chris_user_id, email: "chakrit.lj@gmail.com"})
          |> get(Routes.emoji_path(conn, :list, awa_user_id))
          |> json_response(200)

        assert length(emojis_response) == 2
        assert Enum.at(emojis_response, 0)["id"] == Enum.at(emojis, 0).id
        assert Enum.at(emojis_response, 1)["id"] == Enum.at(emojis, 1).id
      end
    end

    test "Get own emoji by /emoji", %{conn: conn} do
      chris_user_id = Mocks.user_chris().id

      emojis = [
        Mocks.emoji(Mocks.user_awa().id),
        Mocks.emoji(Mocks.user_awa().id)
      ]

      with_mocks [
        {Jarmotion.Service.EmojiService, [],
         list_today_emojis: fn user_id, by_user_id ->
           if(by_user_id == chris_user_id and user_id == chris_user_id) do
             {:ok, emojis}
           else
             {:error, :forbidden}
           end
         end}
      ] do
        emojis_response =
          conn
          |> authenticate(%User{id: chris_user_id, email: "chakrit.lj@gmail.com"})
          |> get(Routes.emoji_path(conn, :list_owner))
          |> json_response(200)

        assert length(emojis_response) == 2
        assert Enum.at(emojis_response, 0)["id"] == Enum.at(emojis, 0).id
        assert Enum.at(emojis_response, 1)["id"] == Enum.at(emojis, 1).id
      end
    end

    test "Get non-friend emoji, should return error", %{conn: conn} do
      with_mocks [
        {Jarmotion.Service.EmojiService, [],
         list_today_emojis: fn _, _ ->
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

    test "Get related people emoji by /emoji/:id?date=xxx", %{conn: conn} do
      chris_user_id = Mocks.user_chris().id
      awa_user_id = Mocks.user_awa().id

      emojis = [
        Mocks.emoji(Mocks.user_awa().id),
        Mocks.emoji(Mocks.user_awa().id)
      ]

      {:ok, finding_date} = Timex.parse("2019-01-01", "{YYYY}-{0M}-{0D}")

      with_mocks [
        {Jarmotion.Service.EmojiService, [],
         list_emojis: fn by_user_id, user_id, date ->
           if(
             by_user_id == chris_user_id and user_id == awa_user_id and
               Timex.compare(date, finding_date) == 0
           ) do
             {:ok, emojis}
           else
             {:error, :forbidden}
           end
         end}
      ] do
        emojis_response =
          conn
          |> authenticate(%User{id: chris_user_id, email: "chakrit.lj@gmail.com"})
          |> get(Routes.emoji_path(conn, :list, awa_user_id, date: "2019-01-01"))
          |> json_response(200)

        assert length(emojis_response) == 2
        assert Enum.at(emojis_response, 0)["id"] == Enum.at(emojis, 0).id
        assert Enum.at(emojis_response, 1)["id"] == Enum.at(emojis, 1).id
      end
    end

    test "return invalid error when date is not correct format", %{conn: conn} do
      chris_user_id = Mocks.user_chris().id
      awa_user_id = Mocks.user_awa().id

      response =
        conn
        |> authenticate(%User{id: chris_user_id, email: "chakrit.lj@gmail.com"})
        |> get(Routes.emoji_path(conn, :list, awa_user_id, date: "aSDFzzz"))
        |> json_response(422)

      assert response["error_message"] == "Invalid date input"
    end
  end

  describe "get /emoji/stats?userid=x&year=y&month=m" do
    @mock_stats [
      %{count: 2, date: ~N[2015-01-23 00:00:00.000000], type: "happy"},
      %{count: 1, date: ~N[2015-01-25 00:00:00.000000], type: "surprised"}
    ]
    test "Should be able to get stats", %{conn: conn} do
      chris_user_id = Mocks.user_chris().id
      awa_user_id = Mocks.user_awa().id

      with_mocks [
        {Jarmotion.Service.EmojiService, [],
         get_max_stats_by_month: fn _by_user_id, _user_id, _year, _month ->
           {:ok, @mock_stats}
         end}
      ] do
        stats_response =
          conn
          |> authenticate(%User{id: chris_user_id, email: "chakrit.lj@gmail.com"})
          |> get(Routes.emoji_path(conn, :stats, user_id: awa_user_id, year: 2015, month: 1))
          |> json_response(200)

        assert length(stats_response) == 2
        assert Enum.at(stats_response, 0)["type"] == "happy"
        assert Enum.at(stats_response, 0)["date"] == "2015-01-23T00:00:00.000000"
        assert Enum.at(stats_response, 1)["type"] == "surprised"
        assert Enum.at(stats_response, 1)["date"] == "2015-01-25T00:00:00.000000"
      end
    end

    test "Wrong input, return invalid input error", %{conn: conn} do
      chris_user_id = Mocks.user_chris().id
      awa_user_id = Mocks.user_awa().id

      conn
      |> authenticate(%User{id: chris_user_id, email: "chakrit.lj@gmail.com"})
      |> get(Routes.emoji_path(conn, :stats, user_id: awa_user_id, yeasssar: 2015, month: 1))
      |> json_response(422)
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
          |> Map.delete(:owner)
          |> Map.put(:owner_id, "null")
          |> Utils.to_keyword_list()

        response =
          conn
          |> authenticate(%User{id: user.id, email: "chakrit.lj@gmail.com"})
          |> post(Routes.emoji_path(conn, :post, emoji))
          |> json_response(200)

        assert response["id"] == Keyword.get(emoji, :id)
        assert response["type"] == Keyword.get(emoji, :type)
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
          |> Map.delete(:owner)
          |> Map.put(:type, "random_emoji_type")
          |> Map.put(:owner_id, "null")
          |> Utils.to_keyword_list()

        build_conn()
        |> authenticate(%User{id: user.id, email: "chakrit.lj@gmail.com"})
        |> post(Routes.emoji_path(conn, :post, emoji))
        |> json_response(422)
      end
    end
  end
end
