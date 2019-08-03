defmodule Jarmotion.Service.EmojiService do
  alias Jarmotion.Repo.{EmojiRepo, RelationshipRepo}
  alias Jarmotion.Schemas.Emoji

  def get_emojis(by_user_id, owner_id) do
    with :ok <- validate_can_see(by_user_id, owner_id) do
      {:ok, EmojiRepo.list_by_owner_id(owner_id)}
    end
  end

  def add_emoji(owner_id, type) do
    Emoji.changeset(%Emoji{}, %{owner_id: owner_id, type: type})
    |> EmojiRepo.insert()
    |> IO.inspect()
  end

  defp validate_can_see(user_id_1, user_id_2) do
    if user_id_1 == user_id_2 or RelationshipRepo.is_friend(user_id_1, user_id_2) do
      :ok
    else
      {:error, :forbidden}
    end
  end
end
