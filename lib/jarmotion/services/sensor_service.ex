defmodule Jarmotion.Service.SensorService do
  alias Jarmotion.Schemas.Sensor
  alias Jarmotion.Repo.{SensorRepo, RelationshipRepo, EmojiRepo, DeviceRepo}

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

  def list_trigger_sensors(owner_id) do
    friend_ids = RelationshipRepo.get_friend_ids(owner_id)
    emoji_stats = EmojiRepo.count_by_type_today(owner_id)
    sensors = SensorRepo.list_by_owners(friend_ids)

    trigger_sensors =
      sensors
      |> Enum.filter(fn sensor ->
        Enum.any?(emoji_stats, fn emoji_stat ->
          emoji_stat.type == sensor.emoji_type and emoji_stat.count >= sensor.threshold
        end)
      end)

    {:ok, trigger_sensors}
  end

  def send_push_to_sensors(sensors) do
    push_result =
      sensors
      |> Enum.map(& &1.id)
      |> DeviceRepo.list_by_sensor_ids()
      |> Enum.map(fn %{sensor: sensor, device: device} ->
        %{
          to: device.token,
          title: "Alert",
          body: "Your partner is #{sensor.emoji_type}.",
          data: %{
            type: "sensor",
            id: sensor.id
          }
        }
      end)
      |> ExponentServerSdk.PushNotification.push_list()

    case push_result do
      {:ok, _} -> :ok
      {:error, _, _} -> {:error, :push_failed}
    end
  end
end
