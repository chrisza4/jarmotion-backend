defmodule Jarmotion.Service.EmojiPostService do
  alias Jarmotion.Schemas.Emoji
  alias Jarmotion.Service.SensorService
  require Logger

  def post_add_emoji(%Emoji{} = emoji) do
    broadcast_emoji(emoji)
  end

  defp broadcast_emoji(emoji) do
    JarmotionWeb.Endpoint.broadcast("user:#{emoji.owner_id}", "emoji:add", %{id: emoji.id})

    Task.async(fn ->
      SensorService.get_trigger_sensors_by_type(emoji.owner_id, emoji.type)
      |> SensorService.send_push(emoji.owner_id)
    end)
  end
end
