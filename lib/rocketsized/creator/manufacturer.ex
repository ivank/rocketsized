defmodule Rocketsized.Creator.Manufacturer do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset

  schema "manufacturers" do
    field :name, :string
    field :short_name, :string
    field :logo, Rocketsized.Creator.Manufacturer.Logo.Type
    field :source, :string

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
    |> cast(attrs, [:name, :source, :short_name])
    |> cast_attachments(attrs, [:logo])
    |> unique_constraint(:name)
    |> validate_required([:name, :logo, :short_name])
  end
end
