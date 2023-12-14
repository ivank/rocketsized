defmodule RocketsizedWeb.Admin.RocketHTML do
  use RocketsizedWeb, :html

  embed_templates "rocket_html/*"

  @doc """
  Renders a vehicle form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def rocket_form(assigns)
end
