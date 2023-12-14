defmodule Rocketsized.Repo.Migrations.CreateLaunches do
  use Ecto.Migration

  def change do
    create table(:launches) do
      add :launched_at, :utc_datetime
      add :status, :string
      add :details, :text
      add :source, :string
      add :vehicle_id, references(:vehicles, on_delete: :nothing)

      timestamps()
    end

    create index(:launches, [:vehicle_id])
  end
end
