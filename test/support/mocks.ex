defmodule Jarmotion.Mocks do
  alias Jarmotion.Schemas.{User, Emoji}

  @user_sample %User{
    id: "59bf0ca9-9865-4a6b-963c-766866fdb6b8",
    email: "test@test.com",
    password: "hash_randomly",
    name: "sample"
  }

  @user_chris %User{
    id: "569d9136-0289-4061-afea-e95b4ca97781",
    email: "chakrit.lj@gmail.com",
    password: "hash_randomly",
    name: "Chris"
  }

  @user_awa %User{
    id: "c7461d62-40cf-4dd0-a162-1dcd69b25b85",
    email: "awa@gmail.com",
    password: "hash_randomly",
    name: "awa"
  }

  def user_sample, do: %User{@user_sample | id: Ecto.UUID.generate()}
  def user_chris, do: @user_chris
  def user_awa, do: @user_awa

  def emoji(owner_id, type \\ "heart"),
    do: %Emoji{
      id: Ecto.UUID.generate(),
      owner_id: owner_id,
      type: type
    }
end
