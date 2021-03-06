defmodule Jarmotion.Service.EmojiService do
  alias Jarmotion.Repo.EmojiRepo
  alias Jarmotion.Schemas.Emoji
  alias Jarmotion.Service.{EmojiPostService, UserService}
  use Timex

  require Logger

  def get_emoji(by_user_id, emoji_id) do
    with {:ok, emoji} <- get_with_err(emoji_id),
         :ok <- UserService.validate_in_relationship(emoji.owner_id, by_user_id) do
      {:ok, emoji}
    else
      {:error, :not_found} -> {:error, :forbidden}
      {:error, err} -> {:error, err}
    end
  end

  def list_today_emojis(by_user_id, owner_id) do
    with :ok <- UserService.validate_in_relationship(by_user_id, owner_id) do
      {:ok, EmojiRepo.list_by_owner_id(owner_id)}
    end
  end

  def list_emojis(by_user_id, owner_id, date) do
    with :ok <- UserService.validate_in_relationship(by_user_id, owner_id) do
      begginning_of_day = Timex.Protocol.beginning_of_day(date)
      end_of_day = Timex.Protocol.end_of_day(date)
      {:ok, EmojiRepo.list_by_owner_id(owner_id, begginning_of_day, end_of_day)}
    end
  end

  def add_emoji(%Emoji{} = emoji) do
    with {:ok, emoji} <- EmojiRepo.insert(emoji) do
      EmojiPostService.post_add_emoji(emoji)
      {:ok, emoji}
    end
  end

  def get_max_stats_by_month(by_user_id, owner_id, year, month) do
    with :ok <- UserService.validate_in_relationship(by_user_id, owner_id) do
      {:ok, EmojiRepo.max_by_month(owner_id, year, month)}
    end
  end

  defp get_with_err(id) do
    case EmojiRepo.get(id) do
      nil -> {:error, :not_found}
      emoji -> {:ok, emoji}
    end
  end
end
