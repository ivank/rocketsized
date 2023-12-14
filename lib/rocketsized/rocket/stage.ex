defmodule Rocketsized.Rocket.Stage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stages" do
    field :propellant, {:array, Ecto.Enum},
      values: [:lox, :lh, :rp1, :udmh, :peroxide, :hydrazine, :n2o, :mmh, :nto, :aerozine]

    field :order, :integer
    field :source, :string

    belongs_to :motor, Rocketsized.Rocket.Motor
    belongs_to :vehicle, Rocketsized.Rocket.Vehicle

    timestamps()
  end

  @doc false
  def changeset(stage, attrs) do
    stage
    |> cast(attrs, [:propellant, :order, :source])
    |> validate_required([:propellant])
  end
end
