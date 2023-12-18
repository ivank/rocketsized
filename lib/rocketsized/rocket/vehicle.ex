defmodule Rocketsized.Rocket.Vehicle do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:id, :name, :state, :country_id, :manufacturer_ids],
    sortable: [:height, :name, :state, :country_id],
    adapter_opts: [
      join_fields: [
        manufacturer_ids: [
          binding: :vehicle_manufacturers,
          field: :id,
          ecto_type: :integer
        ]
      ]
    ]
  }

  @states [:planned, :in_development, :operational, :retired, :canceled]

  schema "vehicles" do
    field :name, :string
    field :source, :string
    field :height, :float
    field :is_published, :boolean, default: false
    field :image, Rocketsized.Vehicle.Image.Type

    field :state, Ecto.Enum, values: @states

    belongs_to :family, Rocketsized.Rocket.Family
    belongs_to :country, Rocketsized.Creator.Country

    has_many :vehicle_manufacturers, Rocketsized.Rocket.VehicleManufacturer, on_replace: :delete

    has_many :manufacturers, through: [:vehicle_manufacturers, :manufacturer]

    timestamps()
  end

  def states() do
    @states
  end

  @doc false
  def changeset(vehicle, attrs) do
    vehicle
    |> cast(attrs, [:name, :source, :height, :state, :is_published, :country_id])
    |> cast_attachments(attrs, [:image])
    |> cast_assoc(:vehicle_manufacturers,
      with: &Rocketsized.Rocket.VehicleManufacturer.changeset/2,
      drop_param: :manufacturer_delete
    )
    |> validate_required_on_field_value(:is_published, %{
      true => [:name, :image, :is_published, :height, :state],
      false => [:name]
    })
  end

  defp validate_required_on_field_value(changeset, field_name, required_map) do
    required = Map.get(required_map, get_field(changeset, field_name))
    if(required, do: validate_required(changeset, required), else: changeset)
  end
end
