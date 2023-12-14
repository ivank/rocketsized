defmodule Rocketsized.Repo.Migrations.CreateStages do
  use Ecto.Migration

  def change do
    create table(:stages) do
      add :propellant, {:array, :string}
      add :vehicle_id, references(:vehicles, on_delete: :nothing)
      add :order, :integer
      add :motor_id, references(:motors, on_delete: :nothing)
      add :source, :string

      timestamps()
    end

    create index(:stages, [:vehicle_id])
  end
end
