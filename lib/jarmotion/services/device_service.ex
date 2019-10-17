defmodule Jarmotion.Service.DeviceService do
  alias Jarmotion.Repo.DeviceRepo
  alias Jarmotion.Schemas.Device

  def regis_device(by_user_id, token) do
    with {:ok, device} <- Device.new(%{owner_id: by_user_id, token: token}) do
      try do
        DeviceRepo.regis_device(device)
      rescue
        _ in Ecto.ConstraintError -> {:error, :forbidden}
      end
    end
  end

  def revoke_device(by_user_id, token) do
    with {1, nil} <- DeviceRepo.revoke(by_user_id, token) do
      :ok
    else
      {0, nil} -> {:error, :not_found}
      e -> e
    end
  end

  def list_devices(user_id) do
    {:ok, DeviceRepo.list_by_user_id(user_id)}
  end
end
