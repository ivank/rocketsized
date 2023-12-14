defmodule RocketsizedWeb.VehicleHTML do
  use RocketsizedWeb, :html

  embed_templates "vehicle_html/*"

  @doc """
  Renders a vehicle form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def vehicle_form(assigns)
end
