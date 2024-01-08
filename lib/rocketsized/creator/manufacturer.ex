defmodule Rocketsized.Creator.Manufacturer do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset

  schema "manufacturers" do
    field :name, :string
    field :short_name, :string
    field :logo, Rocketsized.Creator.Manufacturer.Logo.Type
    field :source, :string
    field :slug, :string

    has_many :vehicle_manufacturers, Rocketsized.Rocket.VehicleManufacturer
    has_many :vehicles, through: [:vehicle_manufacturers, :vehicle]

    timestamps()
  end

  @type t :: %__MODULE__{
          name: String.t() | nil,
          short_name: Float.t() | nil,
          logo: Rocketsized.Creator.Manufacturer.Logo.Type.type(),
          source: String.t() | nil
        }

  @doc false
  def changeset(manufacturer, attrs) do
    manufacturer
    |> cast(attrs, [:name, :source, :short_name, :slug])
    |> cast_attachments(attrs, [:logo])
    |> unique_constraint(:name)
    |> unique_constraint(:slug)
    |> validate_required([:name, :logo, :short_name, :slug])
    |> validate_format(:slug, ~r/^[a-z0-5]+$/, message: "must be only small letters or numbers")
  end
end
