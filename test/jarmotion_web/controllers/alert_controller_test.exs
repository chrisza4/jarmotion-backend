defmodule JarmotionWeb.AlertControllerTest do
  use JarmotionWeb.ConnCase
  alias Jarmotion.Schemas.{User}
  alias Jarmotion.Service.AlertService
  alias Jarmotion.Mocks
  import Mock

  describe "GET /alert" do
    test "Return 200 with alert when user allow to get alert", %{conn: conn} do
      chris_user_id = Mocks.user_chris().id
      awa_user_id = Mocks.user_awa().id
      alert = Mocks.alert_newly_created(awa_user_id, chris_user_id)

      with_mock(AlertService,
        get_alert: fn _, _ -> {:ok, alert} end
      ) do
        response =
          conn
          |> authenticate(%User{id: chris_user_id, email: "chakrit.lj@gmail.com"})
          |> get(Routes.alert_path(conn, :get, alert.id))
          |> json_response(200)

        assert response["id"] == alert.id
        assert response["owner_id"] == alert.owner_id
        assert response["to_user_id"] == alert.to_user_id
        assert response["status"] == "created"
      end
    end

    test "Return 404 with alert for that user not found", %{conn: conn} do
      chris_user_id = Mocks.user_chris().id

      with_mock(AlertService,
        get_alert: fn _, _ -> {:error, :not_found} end
      ) do
        conn
        |> authenticate(%User{id: chris_user_id, email: "chakrit.lj@gmail.com"})
        |> get(Routes.alert_path(conn, :get, "some_random_aler"))
        |> json_response(404)
      end
    end
  end

  describe "POST /alert" do
    test "return 200 with new alert when success", %{conn: conn} do
      chris_user_id = Mocks.user_chris().id
      awa_user_id = Mocks.user_awa().id
      alert = Mocks.alert_newly_created(awa_user_id, chris_user_id)

      with_mock(AlertService,
        add_alert: fn _, _ -> {:ok, alert} end
      ) do
        response =
          conn
          |> authenticate(%User{id: chris_user_id, email: "chakrit.lj@gmail.com"})
          |> post(Routes.alert_path(conn, :post, to_user_id: awa_user_id))
          |> json_response(200)

        assert response["id"] == alert.id
        assert response["owner_id"] == alert.owner_id
        assert response["to_user_id"] == alert.to_user_id
        assert response["status"] == "created"
      end
    end

    test "return 404 with new alert when params not correct", %{conn: conn} do
      chris_user_id = Mocks.user_chris().id

      conn
      |> authenticate(%User{id: chris_user_id, email: "chakrit.lj@gmail.com"})
      |> post(Routes.alert_path(conn, :post, too_users_ids: "nothing"))
      |> json_response(404)
    end
  end

  describe "GET /alerts" do
    test "Return 200 with list of alerts", %{conn: conn} do
      chris_user_id = Mocks.user_chris().id
      awa_user_id = Mocks.user_awa().id

      alerts = [
        Mocks.alert_newly_created(awa_user_id, chris_user_id),
        Mocks.alert_newly_created(awa_user_id, chris_user_id)
      ]

      with_mock(AlertService,
        list_recent_alerts: fn _ -> {:ok, alerts} end
      ) do
        response =
          conn
          |> authenticate(%User{id: chris_user_id, email: "chakrit.lj@gmail.com"})
          |> get(Routes.alert_path(conn, :list_recent))
          |> json_response(200)

        assert length(response) == 2
        [alert1, alert2] = alerts
        assert Enum.any?(response, &(&1["id"] == alert1.id))
        assert Enum.any?(response, &(&1["id"] == alert2.id))
      end
    end
  end
end
