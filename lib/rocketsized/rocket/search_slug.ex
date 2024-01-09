defmodule Rocketsized.Rocket.SearchSlug do
  use Ecto.Schema

  @primary_key false
  schema "search_slugs" do
    field :type, Ecto.Enum, values: [:rocket, :country, :org]
    field :slug, :string
    field :title, :string
    field :subtitle, :string
    field :source, :string
    field :image, :string
  end

  @type t :: %__MODULE__{
          type: :rocket | :country | :org,
          slug: String.t(),
          title: String.t(),
          image: String.t() | nil,
          source: String.t() | nil,
          subtitle: String.t() | nil
        }
end
