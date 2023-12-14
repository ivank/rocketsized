defmodule Rocketsized.Repo.Migrations.CreateVehicles do
  use Ecto.Migration

  def change do
    create table(:vehicles) do
      add :name, :string
      add :state, :string
      add :height, :float
      add :source, :string
      add :country_id, references(:countries, on_delete: :nothing)
      add :family_id, references(:families, on_delete: :nothing)

      timestamps()
    end

    create index(:vehicles, [:family_id])
    create index(:vehicles, [:country_id])

    create unique_index(:vehicles, [:name, :country_id])

    create table(:vehicle_manufacturers) do
      add :source, :string
      add :vehicle_id, references(:vehicles, on_delete: :nothing)
      add :manufacturer_id, references(:manufacturers, on_delete: :nothing)

      timestamps()
    end

    create index(:vehicle_manufacturers, [:vehicle_id])
    create index(:vehicle_manufacturers, [:manufacturer_id])
    create unique_index(:vehicle_manufacturers, [:vehicle_id, :manufacturer_id])
  end
end
