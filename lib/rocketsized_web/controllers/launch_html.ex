defmodule RocketsizedWeb.LaunchHTML do
  use RocketsizedWeb, :html

  embed_templates "launch_html/*"

  @doc """
  Renders a launch form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def launch_form(assigns)
end
