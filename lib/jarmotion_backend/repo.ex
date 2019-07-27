defmodule JarmotionBackend.Repo do
  use Ecto.Repo,
    otp_app: :jarmotion_backend,
    adapter: Ecto.Adapters.Postgres
end
