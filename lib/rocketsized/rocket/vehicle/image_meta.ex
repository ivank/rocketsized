defmodule Rocketsized.Rocket.Vehicle.ImageMeta do
  use Ecto.Schema
  import Ecto.Changeset

  @image_license %{
    "Royalty Free" => :rf,
    "Royalty Managed" => :rm,
    "Creative Commons Attribution" => :cc_by,
    "Creative Commons Attribution Share Alike" => :cc_by_sa,
    "Creative Commons Attribution No Derivatives" => :cc_by_nd,
    "Creative Commons Attribution Non Commercial" => :cc_by_nc,
    "Public Domain" => :public_domain,
    "Unknown" => :unknown,
    "Copyright Ivan Kerin" => :ivan_kerin,
    "Copyright Rocketsized" => :rocketsized
  }
  @image_type [:png, :svg, :jpg, :webp, :heif]

  embedded_schema do
    field :width, :float
    field :height, :float
    field :license, Ecto.Enum, values: Map.values(@image_license)
    field :attribution, :string
    field :type, Ecto.Enum, values: @image_type
  end

  def image_licenses(), do: @image_license
  def image_types(), do: @image_type

  def changeset(meta, attrs \\ %{}) do
    meta
    |> cast(attrs, [:width, :height, :license, :attribution, :type])
    |> validate_required([:width, :height, :license])
  end
end
