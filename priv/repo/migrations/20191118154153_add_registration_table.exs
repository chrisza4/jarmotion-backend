defmodule Jarmotion.Repo.Migrations.AddRegistrationTable do
  use Ecto.Migration

  def change do
    create table(:registrations, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :code, :string, null: false
      add :owner_id, references(:users)

      timestamps()
    end

    create index("registrations", [:owner_id])
    create unique_index("registrations", [:code])
  end
end
