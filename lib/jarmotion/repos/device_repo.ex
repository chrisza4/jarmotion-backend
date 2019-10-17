defmodule Jarmotion.Repo.DeviceRepo do
  import Ecto.Query
  alias Jarmotion.Schemas.Device
  alias Jarmotion.Repo

  def regis_device(%Device{} = device) do
    current_device = Repo.get_by(Device, token: device.token, owner_id: device.owner_id)

    case current_device do
      nil -> Repo.insert(device)
      _ -> {:ok, current_device}
    end
  end

  def list_by_user_id(user_id) do
    from(device in Device,
      where: device.owner_id == ^user_id,
      order_by: [desc: device.inserted_at],
      select: device
    )
    |> Repo.all()
  end

  def revoke(user_id, token) do
    from(device in Device, where: device.owner_id == ^user_id and device.token == ^token)
    |> Repo.delete_all()
  end
end
