defmodule Rocketsized.Repo.Migrations.Render do
  use Ecto.Migration

  def change do
    create table(:renders) do
      add :filters, {:array, :string}
      add :type, :string
      add :image, :string

      timestamps()
    end

    create unique_index(:renders, [:filters, :type])
  end
end
