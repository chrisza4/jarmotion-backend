defmodule JarmotionWeb.DeviceControllerTest do
  use JarmotionWeb.ConnCase
  alias Jarmotion.Schemas.{User}
  alias Jarmotion.Service.DeviceService
  alias Jarmotion.Mocks
  import Mock

  describe "POST /device" do
    test "return 200 with new device post success", %{conn: conn} do
      chris_user_id = Mocks.user_chris().id
      device = Mocks.device(chris_user_id, "token1")

      with_mock(DeviceService,
        regis_device: fn _, _ -> {:ok, device} end
      ) do
        response =
          conn
          |> authenticate(%User{id: chris_user_id, email: "chakrit.lj@gmail.com"})
          |> post(Routes.device_path(conn, :post, token: "token1"))
          |> json_response(200)

        assert response["id"] == device.id
        assert response["owner_id"] == device.owner_id
        assert response["token"] == device.token
      end
    end

    test "return 403 with invalid registration", %{conn: conn} do
      chris_user_id = Mocks.user_chris().id

      with_mock(DeviceService,
        regis_device: fn _, _ -> {:error, :forbidden} end
      ) do
        conn
        |> authenticate(%User{id: chris_user_id, email: "chakrit.lj@gmail.com"})
        |> post(Routes.device_path(conn, :post, token: "token1"))
        |> json_response(403)
      end
    end
  end

  describe "DELETE /device/:id" do
    test "return 200 with revoke device success", %{conn: conn} do
      chris_user_id = Mocks.user_chris().id

      with_mock(DeviceService,
        revoke_device: fn _, _ -> :ok end
      ) do
        response =
          conn
          |> authenticate(%User{id: chris_user_id, email: "chakrit.lj@gmail.com"})
          |> delete(Routes.device_path(conn, :delete, "token1"))
          |> json_response(200)

        assert response["ok"]
      end
    end
  end
end
