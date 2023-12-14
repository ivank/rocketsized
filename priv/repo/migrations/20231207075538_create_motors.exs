defmodule Rocketsized.Repo.Migrations.CreateMotors do
  use Ecto.Migration

  def change do
    create table(:motors) do
      add :cycle, :string
      add :isp_space, :float
      add :isp_sea, :float
      add :thrust, :float
      add :chamber_pressure, :float
      add :weight, :float
      add :source, :string
      add :predecessor_id, references(:motors, on_delete: :nothing)

      timestamps()
    end

    create index(:motors, [:predecessor_id])
  end
end
