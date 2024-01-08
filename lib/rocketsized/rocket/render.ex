defmodule Rocketsized.Rocket.Render do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset

  schema "renders" do
    field :filters, {:array, :string}
    field :type, Ecto.Enum, values: [:poster_portrait, :poster_landscape, :wallpaper]
    field :image, Rocketsized.Rocket.Render.Image.Type

    timestamps()
  end

  @type t :: %__MODULE__{
          filters: list(Rocketsized.Rocket.VehicleFilter.Type.type()),
          image: Rocketsized.Rocket.Vehicle.Image.Type.type(),
          type: :poster_portrait | :poster_landscape | :wallpaper
        }

  @doc false
  def changeset(render, attrs) do
    render
    |> cast(attrs, [:filters, :type])
    |> cast_attachments(attrs, [:image])
    |> validate_required([:image, :filters, :type])
  end
end
