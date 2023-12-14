defmodule RocketsizedWeb.FamilyHTML do
  use RocketsizedWeb, :html

  embed_templates "family_html/*"

  @doc """
  Renders a family form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def family_form(assigns)
end
