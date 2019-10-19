defmodule Jarmotion.Service.SensorService do
  alias Jarmotion.Schemas.Sensor
  alias Jarmotion.Repo.{SensorRepo, RelationshipRepo, EmojiRepo}

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

  def list_notifier_ids(owner_id) do
    friend_ids = RelationshipRepo.get_friend_ids(owner_id)
    emoji_stats = EmojiRepo.count_by_type_today(owner_id)
    sensors = SensorRepo.list_by_owners(friend_ids)

    owner_ids =
      sensors
      |> Enum.filter(fn sensor ->
        Enum.any?(emoji_stats, fn emoji_stat ->
          emoji_stat.type == sensor.emoji_type and emoji_stat.count >= sensor.threshold
        end)
      end)
      |> Enum.map(& &1.owner_id)

    {:ok, owner_ids}
  end
end
