defmodule Rocketsized.Rocket.Launch do
  use Ecto.Schema
  import Ecto.Changeset

  schema "launches" do
    field :status, Ecto.Enum, values: [:success, :failure, :partial]
    field :launched_at, :utc_datetime
    field :details, :string
    field :source, :string

    belongs_to :vehicle, Rocketsized.Rocket.Vehicle

    timestamps()
  end

  @doc false
  def changeset(launch, attrs) do
    launch
    |> cast(attrs, [:launched_at, :status, :details, :source])
    |> validate_required([:launched_at, :status, :details])
  end
end
