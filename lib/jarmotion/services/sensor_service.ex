defmodule Jarmotion.Service.SensorService do
  alias Jarmotion.Schemas.Sensor
  alias Jarmotion.Repo.{SensorRepo, RelationshipRepo, EmojiRepo, DeviceRepo, UserRepo}

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

  def get_trigger_sensors_by_type(owner_id, type) do
    friend_ids = RelationshipRepo.get_friend_ids(owner_id)
    emoji_stats = EmojiRepo.count_by_type_today(owner_id, type)
    sensors = SensorRepo.list_by_owners_and_type(friend_ids, type)

    trigger_sensors =
      sensors
      |> Enum.filter(fn sensor ->
        Enum.any?(emoji_stats, fn emoji_stat ->
          emoji_stat.count >= sensor.threshold
        end)
      end)

    trigger_sensors
  end

  def send_push(sensors, from_user_id) do
    user = UserRepo.get(from_user_id)

    push_result =
      sensors
      |> Enum.map(& &1.id)
      |> DeviceRepo.list_by_sensor_ids()
      |> Enum.map(fn %{sensor: sensor, device: device} ->
        %{
          to: device.token,
          title: "Alert",
          body: "#{user.name} is currently #{sensor.emoji_type}.",
          data: %{
            type: "sensor",
            id: sensor.id
          },
          sound: "default"
        }
      end)
      |> ExponentServerSdk.PushNotification.push_list()

    case push_result do
      {:ok, _} -> :ok
      {:error, _, _} -> {:error, :push_failed}
    end
  end
end
