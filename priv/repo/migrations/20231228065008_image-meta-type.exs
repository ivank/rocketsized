defmodule :"Elixir.Rocketsized.Repo.Migrations.Image-meta-type" do
  use Ecto.Migration

  def change do
    alter table(:vehicles) do
      add :image_meta, :map
    end
  end
end
