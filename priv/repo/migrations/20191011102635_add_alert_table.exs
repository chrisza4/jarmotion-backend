defmodule Jarmotion.Repo.Migrations.AddAlertTable do
  use Ecto.Migration

  def change do
    create table(:alerts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :status, :string
      add :owner_id, references(:users)
      add :to_user_id, references(:users)

      timestamps()
    end

    create index("alerts", [:owner_id])
    create index("alerts", [:to_user_id])
    create index("alerts", [:inserted_at])
  end
end
