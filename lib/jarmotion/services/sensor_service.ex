defmodule Jarmotion.Service.SensorService do
  alias Jarmotion.Schemas.Sensor
  alias Jarmotion.Repo.SensorRepo

  def upsert_sensor(by_user_id, type, threshold) do
    with {:ok, sensor} <-
           Sensor.new(%{threshold: threshold, emoji_type: type, owner_id: by_user_id}) do
      SensorRepo.upsert(sensor)
    end
  end

  def delete_sensor(by_user_id, type) do
    with {1, nil} <- SensorRepo.delete_by_owner_and_type(by_user_id, type) do
      :ok
    else
      {0, _} -> {:error, :not_found}
      {:error, err} -> {:error, err}
    end
  end

  def list_sensors(by_user_id) do
    {:ok, SensorRepo.list_by_owner(by_user_id)}
  end
end
