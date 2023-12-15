defmodule RocketsizedWeb.Admin.OrgHTML do
  use RocketsizedWeb, :html
  import RocketsizedWeb.Admin.Components

  embed_templates "org_html/*"

  @doc """
  Renders a vehicle form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def resource_form(assigns)
end
