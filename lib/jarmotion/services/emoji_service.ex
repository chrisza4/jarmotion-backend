defmodule Jarmotion.Service.EmojiService do
  alias Jarmotion.Repo.{EmojiRepo, RelationshipRepo}
  alias Jarmotion.Schemas.Emoji

  def get_emoji(by_user_id, emoji_id) do
    with {:ok, emoji} <- get_with_err(emoji_id),
         :ok <- validate_can_see(emoji.owner_id, by_user_id) do
      {:ok, emoji}
    else
      {:error, :not_found} -> {:error, :forbidden}
      {:error, err} -> {:error, err}
    end
  end

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

  defp get_with_err(id) do
    case EmojiRepo.get(id) do
      nil -> {:error, :not_found}
      emoji -> {:ok, emoji}
    end
  end
end
