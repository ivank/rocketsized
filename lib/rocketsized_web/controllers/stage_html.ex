defmodule RocketsizedWeb.StageHTML do
  use RocketsizedWeb, :html

  embed_templates "stage_html/*"

  @doc """
  Renders a stage form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def stage_form(assigns)
end
