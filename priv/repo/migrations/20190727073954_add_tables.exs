defmodule JarmotionBackend.Repo.Migrations.AddTables do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :email, :string

      timestamps()
    end
  end
end
