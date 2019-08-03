defmodule Jarmotion.Repo.Migrations.AddEmojiTable do
  use Ecto.Migration

  def change do
    create table(:emojis, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :type, :string
      add :owner_id, references(:users)

      timestamps()
    end

    create index("emojis", [:owner_id])
    create index("emojis", [:inserted_at])
  end
end
