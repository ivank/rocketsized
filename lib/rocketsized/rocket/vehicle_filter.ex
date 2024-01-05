defmodule Rocketsized.Rocket.VehicleFilter do
  use Ecto.Schema

  @primary_key false
  schema "vehicle_filters" do
    field :type, Ecto.Enum, values: [:vehicle, :country, :manufacturer]
    field :id, :integer
    field :title, :string
    field :subtitle, :string
    field :source, :string
    field :image, :string
  end

  @type t :: %__MODULE__{
          type: :vehicle | :country | :manufacturer,
          id: integer(),
          title: String.t(),
          image: String.t() | nil,
          source: String.t() | nil,
          subtitle: String.t() | nil
        }
end
