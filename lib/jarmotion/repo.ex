defmodule Jarmotion.Repo do
  use Ecto.Repo,
    otp_app: :jarmotion,
    adapter: Ecto.Adapters.Postgres
end
