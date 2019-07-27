defmodule JarmotionBackend.Repo.Migrations.UniqueEmail do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:email], name: :users_email_index)
  end
end
