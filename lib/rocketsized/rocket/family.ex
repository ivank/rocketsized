defmodule Rocketsized.Rocket.Family do
  use Ecto.Schema
  import Ecto.Changeset

  schema "families" do
    field :name, :string
    field :source, :string

    belongs_to :parent, Rocketsized.Rocket.Family

    timestamps()
  end

  @doc false
  def changeset(family, attrs) do
    family
    |> cast(attrs, [:name, :source])
    |> validate_required([:name])
  end
end
