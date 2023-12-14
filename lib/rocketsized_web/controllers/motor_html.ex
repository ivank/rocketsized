defmodule RocketsizedWeb.MotorHTML do
  use RocketsizedWeb, :html

  embed_templates "motor_html/*"

  @doc """
  Renders a motor form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def motor_form(assigns)
end
