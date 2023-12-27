defmodule Rocketsized.Rocket.Vehicle do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:id, :name, :state, :country_id, :manufacturer_ids, :search],
    sortable: [:id, :height, :name, :state, :country_id],
    default_order: %{order_by: [:height, :id], order_directions: [:desc, :desc]},
    default_limit: 16,
    default_pagination_type: :first,
    max_limit: 50,
    adapter_opts: [
      join_fields: [
        manufacturer_ids: [
          binding: :vehicle_manufacturers,
          field: :manufacturer_id,
          ecto_type: :integer
        ]
      ],
      custom_fields: [
        search: [
          bindings: [:vehicle_manufacturers],
          filter: {Rocketsized.Rocket.VehicleFilter.Type, :search, []},
          ecto_type: Rocketsized.Rocket.VehicleFilter.Type,
          operators: [:in]
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
    field :image, Rocketsized.Rocket.Vehicle.Image.Type
    field :description, :string
    field :native_name, :string
    field :alternative_name, :string
    field :diameter, :float

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
    |> cast(attrs, [
      :name,
      :source,
      :height,
      :diameter,
      :state,
      :is_published,
      :country_id,
      :description,
      :native_name,
      :alternative_name
    ])
    |> unique_constraint([:name, :country_id], name: "vehicles_name_country_id_index")
    |> cast_attachments(attrs, [:image])
    |> cast_assoc(:vehicle_manufacturers,
      with: &Rocketsized.Rocket.VehicleManufacturer.changeset/2,
      drop_param: :drop_vehicle_manufacturers
    )
    |> cast_add_assoc(attrs, :vehicle_manufacturers, add_param: :add_vehicle_manufacturers)
    |> validate_required_on_field_value(:is_published, %{
      true => [:name, :image, :is_published, :height, :state, :country_id],
      false => [:name]
    })
  end

  defp cast_add_assoc(%Ecto.Changeset{} = changeset, attrs, assoc, add_param: add_param) do
    if Map.has_key?(attrs, Atom.to_string(add_param)) do
      new = Ecto.build_assoc(changeset.data, assoc)
      current = get_in(changeset.data, [Access.key(assoc)])
      updated = if Ecto.assoc_loaded?(current), do: current ++ [new], else: [new]
      %{Ecto.Changeset.put_assoc(changeset, assoc, updated) | valid?: false}
    else
      changeset
    end
  end

  defp validate_required_on_field_value(changeset, field_name, required_map) do
    required = Map.get(required_map, get_field(changeset, field_name))
    if(required, do: validate_required(changeset, required), else: changeset)
  end
end
