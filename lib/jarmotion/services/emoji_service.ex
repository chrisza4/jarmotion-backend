defmodule Jarmotion.Service.EmojiService do
  alias Jarmotion.Repo.{EmojiRepo, RelationshipRepo}
  alias Jarmotion.Schemas.Emoji

  defp broadcast_emoji({:error, err}), do: {:error, err}

  defp broadcast_emoji({:ok, emoji}) do
    Task.async(fn ->
      # This might require error handling
      JarmotionWeb.Endpoint.broadcast("user:#{emoji.owner_id}", "emoji:add", %{id: emoji.id})
    end)

    {:ok, emoji}
  end

  # Unexpected input
  defp broadcast_emoji(a), do: a

  def get_emojis(by_user_id, owner_id) do
    with :ok <- validate_can_see(by_user_id, owner_id) do
      {:ok, EmojiRepo.list_by_owner_id(owner_id)}
    end
  end

  def add_emoji(%Emoji{} = emoji) do
    EmojiRepo.insert(emoji) |> broadcast_emoji()
  end

  defp validate_can_see(user_id_1, user_id_2) do
    if user_id_1 == user_id_2 or RelationshipRepo.is_friend(user_id_1, user_id_2) do
      :ok
    else
      {:error, :forbidden}
    end
  end
end
