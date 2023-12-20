defmodule Rocketsized.Repo.Migrations.RefineVehicleData do
  use Ecto.Migration

  def change do
    alter table(:vehicles) do
      add :description, :string
      add :native_name, :string
      add :diameter, :float
      add :alternative_name, :string
    end

    alter table(:manufacturers) do
      add :short_name, :string
    end
  end
end
