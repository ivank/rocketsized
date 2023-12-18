defmodule RocketsizedWeb.Admin.RocketHTML do
  use RocketsizedWeb, :html
  import RocketsizedWeb.Admin.Components

  embed_templates "rocket_html/*"

  @doc """
  Renders a vehicle form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :countries, :list
  attr :manufacturers, :list

  def resource_form(assigns)
end
