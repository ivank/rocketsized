defmodule Rocketsized.Creator.Country do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset

  schema "countries" do
    field :code, :string
    field :name, :string
    field :flag, Rocketsized.Country.Flag.Type
    field :source, :string

    has_many :vehicles, Rocketsized.Rocket.Vehicle

    timestamps()
  end

  @doc false
  def changeset(country, attrs) do
    country
    |> cast(attrs, [:name, :code, :source])
    |> cast_attachments(attrs, [:flag])
    |> validate_required([:name, :code, :flag])
  end
end
