defmodule Jarmotion.Repo.Migrations.CreateDevices do
  use Ecto.Migration

  def change do
    create table(:devices, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :token, :string
      add :owner_id, references(:users)
      timestamps()
    end

    create index("devices", [:owner_id])
    create index("devices", [:inserted_at])
  end
end
