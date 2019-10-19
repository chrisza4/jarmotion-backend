defmodule Jarmotion.Repo.Migrations.CreateSensors do
  use Ecto.Migration

  def change do
    create table(:sensors, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :owner_id, references(:users)
      add :emoji_type, :string
      add :threshold, :integer
      timestamps()
    end

    create index("sensors", [:owner_id])
    create unique_index(:sensors, [:owner_id, :emoji_type])
  end
end
