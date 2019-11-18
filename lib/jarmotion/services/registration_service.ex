defmodule Jarmotion.Service.RegistrationService do
  alias Jarmotion.Repo.{UserRepo, RegistrationRepo}
  alias Jarmotion.Repo
  alias Jarmotion.Schemas.{User, Registration}

  def generate() do
    %Registration{
      code: Registration.generate_code()
    }
    |> RegistrationRepo.insert()
  end

  def register(code, user_info) do
    registration = RegistrationRepo.find_unregister_code(code)
    registered_user = UserRepo.get_by_email(user_info.email)

    cond do
      registration == nil ->
        {:error, :forbidden}

      registered_user != nil ->
        {:error, :duplicate}

      true ->
        Repo.transaction(fn ->
          with {:ok, user} <-
                 User.new(user_info) |> UserRepo.insert() do
            RegistrationRepo.register_for_user_id(registration, user.id)
            user
          end
        end)
    end
  end
end
