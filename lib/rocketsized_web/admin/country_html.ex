defmodule RocketsizedWeb.Admin.CountryHTML do
  use RocketsizedWeb, :html
  import RocketsizedWeb.Admin.Components

  embed_templates "country_html/*"

  @doc """
  Renders a vehicle form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def rocket_form(assigns)
end
