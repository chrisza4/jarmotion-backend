defmodule Jarmotion.Repo.SensorRepo do
  import Ecto.Query
  alias Jarmotion.Schemas.Sensor
  alias Jarmotion.Repo

  def upsert(%Sensor{} = sensor) do
    Repo.insert(sensor,
      on_conflict: [set: [threshold: sensor.threshold]],
      conflict_target: [:owner_id, :emoji_type],
      returning: true
    )
  end

  def get(id), do: Repo.get(Sensor, id)

  def list_by_owner(user_id) do
    from(sensor in Sensor,
      where: sensor.owner_id == ^user_id,
      select: sensor
    )
    |> Repo.all()
  end

  def delete_by_owner_and_type(user_id, emoji_type) do
    from(sensor in Sensor,
      where: sensor.owner_id == ^user_id and sensor.emoji_type == ^emoji_type
    )
    |> Repo.delete_all()
  end
end
