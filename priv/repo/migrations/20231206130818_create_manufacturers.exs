defmodule Rocketsized.Repo.Migrations.CreateManufacturers do
  use Ecto.Migration

  def change do
    create table(:manufacturers) do
      add :name, :string
      add :flag, :text
      add :source, :string

      timestamps()
    end

    create unique_index(:manufacturers, [:name])
  end
end
