defmodule Rocketsized.Repo.Migrations.CreateCountries do
  use Ecto.Migration

  def change do
    create table(:countries) do
      add :name, :string
      add :flag, :text
      add :code, :string
      add :source, :string

      timestamps()
    end

    create unique_index(:countries, [:name])
  end
end
