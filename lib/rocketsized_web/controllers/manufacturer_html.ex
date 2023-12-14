defmodule RocketsizedWeb.ManufacturerHTML do
  use RocketsizedWeb, :html

  embed_templates "manufacturer_html/*"

  @doc """
  Renders a Manufacturer form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def manufacturer_form(assigns)
end
