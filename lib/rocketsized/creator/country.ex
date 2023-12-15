defmodule Rocketsized.Creator.Country do
  use Ecto.Schema
  import Ecto.Changeset

  schema "countries" do
    field :code, :string
    field :name, :string
    field :flag, :string
    field :source, :string

    has_many :vehicles, Rocketsized.Rocket.Vehicle

    timestamps()
  end

  @doc false
  def changeset(country, attrs) do
    country
    |> cast(attrs, [:name, :code, :flag, :source])
    |> validate_required([:name, :code, :flag])
  end
end
