defmodule JarmotionWeb.DeviceController do
  use JarmotionWeb, :controller
  alias Jarmotion.Service.DeviceService

  action_fallback JarmotionWeb.ErrorController

  def post(conn, %{"token" => token}) do
    by_user_id = current_user_id(conn)

    with {:ok, device} <- DeviceService.regis_device(by_user_id, token) do
      render(conn, "device.json", %{device: device})
    end
  end

  def post(_, _) do
    {:error, :not_found}
  end

  def delete(conn, %{"token" => token}) do
    by_user_id = current_user_id(conn)

    with :ok <- DeviceService.revoke_device(by_user_id, token) do
      render(conn, "success.json")
    end
  end

  def delete(_, _) do
    {:error, :not_found}
  end
end
