defmodule Rocketsized.Rocket.Motor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "motors" do
    field :cycle, Ecto.Enum,
      values: [
        :pressure_fed,
        :electric_pump_fed,
        :gas_generator,
        :tap_off,
        :expander,
        :staged_combustion,
        :full_flow_staged_combustion
      ]

    field :isp_space, :float
    field :isp_sea, :float
    field :thrust, :float
    field :chamber_pressure, :float
    field :weight, :float
    field :source, :string

    belongs_to :predecessor, Rocketsized.Rocket.Motor
    has_many :stages, Rocketsized.Rocket.Stage
    has_many :vehicles, through: [:stages, :vehicle]

    timestamps()
  end

  @doc false
  def changeset(motor, attrs) do
    motor
    |> cast(attrs, [:cycle, :isp_space, :isp_sea, :thrust, :chamber_pressure, :weight, :source])
    |> validate_required([:cycle, :isp_space, :isp_sea, :thrust, :chamber_pressure, :weight])
  end
end
