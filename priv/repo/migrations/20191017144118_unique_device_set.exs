defmodule Jarmotion.Repo.Migrations.UniqueDeviceSet do
  use Ecto.Migration

  def change do
    create unique_index(:devices, [:owner_id, :token])
  end
end
