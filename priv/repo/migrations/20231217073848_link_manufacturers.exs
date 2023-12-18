defmodule Rocketsized.Repo.Migrations.LinkManufacturers do
  use Ecto.Migration

  def change do
    alter table(:vehicle_manufacturers) do
      modify :vehicle_id, references(:vehicles, on_delete: :delete_all),
        from: references(:vehicles, on_delete: :nothing)

      modify :manufacturer_id, references(:manufacturers, on_delete: :delete_all),
        from: references(:manufacturers, on_delete: :nothing)
    end

    alter table(:launches) do
      modify :vehicle_id, references(:vehicles, on_delete: :delete_all),
        from: references(:vehicles, on_delete: :nothing)
    end

    alter table(:stages) do
      modify :vehicle_id, references(:vehicles, on_delete: :nothing),
        from: references(:vehicles, on_delete: :nothing)
    end
  end
end
