defmodule Rocketsized.Repo.Migrations.CreateFamilies do
  use Ecto.Migration

  def change do
    create table(:families) do
      add :name, :string
      add :parent_id, references(:families, on_delete: :nothing)
      add :source, :string

      timestamps()
    end

    create index(:families, [:parent_id])
  end
end
