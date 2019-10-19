defmodule JarmotionWeb.SensorControllerTest do
  use JarmotionWeb.ConnCase
  alias Jarmotion.Schemas.{User}
  alias Jarmotion.Service.SensorService
  alias Jarmotion.Mocks
  import Mock

  describe "POST /sensors" do
    test "return 200 with new sensor post success", %{conn: conn} do
      chris_user_id = Mocks.user_chris().id
      sensor = Mocks.sensor(chris_user_id, "love", 4)

      with_mock(SensorService,
        upsert_sensor: fn _, _, _ -> {:ok, sensor} end
      ) do
        response =
          conn
          |> authenticate(%User{id: chris_user_id, email: "chakrit.lj@gmail.com"})
          |> post(Routes.sensor_path(conn, :post, emoji_type: "love", threshold: 4))
          |> json_response(200)

        assert response["id"] == sensor.id
        assert response["threshold"] == sensor.threshold
        assert response["emoji_type"] == sensor.emoji_type
      end
    end

    test "return 422 with invalid emoji type", %{conn: conn} do
      chris_user_id = Mocks.user_chris().id

      conn
      |> authenticate(%User{id: chris_user_id, email: "chakrit.lj@gmail.com"})
      |> post(Routes.sensor_path(conn, :post, emoji_type: "x", threshold: 4))
      |> json_response(422)
    end

    test "return 422 with invalid threshold", %{conn: conn} do
      chris_user_id = Mocks.user_chris().id

      conn
      |> authenticate(%User{id: chris_user_id, email: "chakrit.lj@gmail.com"})
      |> post(Routes.sensor_path(conn, :post, emoji_type: "love", threshold: -1))
      |> json_response(422)
    end
  end

  describe "GET /sensors" do
    test "Return list of sensor", %{conn: conn} do
      chris_user_id = Mocks.user_chris().id
      sensor = Mocks.sensor(chris_user_id, "love", 4)

      with_mock(SensorService,
        list_sensors: fn user_id ->
          if chris_user_id == user_id do
            {:ok, [sensor]}
          else
            {:error, :forbidden}
          end
        end
      ) do
        response =
          conn
          |> authenticate(%User{id: chris_user_id, email: "chakrit.lj@gmail.com"})
          |> get(Routes.sensor_path(conn, :list))
          |> json_response(200)

        assert length(response) == 1
      end
    end
  end

  describe "Delete /sensors" do
    test "Return 200 if delete success", %{conn: conn} do
      chris_user_id = Mocks.user_chris().id

      with_mock(SensorService,
        delete_sensor: fn _, _ -> :ok end
      ) do
        response =
          conn
          |> authenticate(%User{id: chris_user_id, email: "chakrit.lj@gmail.com"})
          |> delete(Routes.sensor_path(conn, :delete, emoji_type: "love"))
          |> json_response(200)

        assert response["ok"]
      end
    end
  end
end
