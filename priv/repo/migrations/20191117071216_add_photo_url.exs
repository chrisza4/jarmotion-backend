defmodule Jarmotion.Repo.Migrations.AddPhotoUrl do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :photo_id, :string
    end
  end
end
