defmodule Rocketsized.Repo.Migrations.Slugs do
  use Ecto.Migration

  def change do
    alter table(:vehicles) do
      add :slug, :string
    end

    create unique_index(:vehicles, [:slug])

    alter table(:manufacturers) do
      add :slug, :string
    end

    create unique_index(:manufacturers, [:slug])
  end
end
