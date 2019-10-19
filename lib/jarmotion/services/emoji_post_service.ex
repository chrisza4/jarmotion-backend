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
      SensorService.list_trigger_sensors(emoji.owner_id) |> SensorService.send_push_to_sensors()
    end)
  end
end
