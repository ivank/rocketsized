defmodule Rocketsized.Repo.Migrations.AddVehicleAndManufacturerColumns do
  use Ecto.Migration

  def change do
    alter table(:vehicles) do
      add :image, :string
      add :is_published, :boolean, default: false, null: false
    end

    rename table(:manufacturers), :flag, to: :logo
  end
end
