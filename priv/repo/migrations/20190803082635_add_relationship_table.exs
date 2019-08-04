defmodule Jarmotion.Repo.Migrations.AddRelationshipTable do
  use Ecto.Migration

  def change do
    create table(:relationship, primary_key: false) do
      add(:user_id_1, references(:users, on_delete: :delete_all), primary_key: true)
      add(:user_id_2, references(:users, on_delete: :delete_all), primary_key: true)
      timestamps()
    end
  end
end
