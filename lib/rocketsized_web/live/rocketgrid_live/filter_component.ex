defmodule RocketsizedWeb.RocketgridLive.FilterComponent do
  use RocketsizedWeb, :live_component

  import Flop.Phoenix

  attr :meta, Flop.Meta, required: true
  attr :id, :string, default: nil
  attr :on_change, :string
  attr :target, :string, default: nil

  @impl true
  def render(%{meta: meta} = assigns) do
    assigns = assign(assigns, form: Phoenix.Component.to_form(meta), meta: nil)

    ~H"""
    <div>
      <.form for={@form} id={@id} phx-target={@target} phx-change={@on_change} phx-submit={@on_change}>
        <.filter_fields
          :let={f}
          form={@form}
          fields={[
            name: [
              label: "Name",
              op: :ilike_and
            ],
            state: [
              label: "State",
              type: "select",
              prompt: "",
              options: Rocketsized.Rocket.Vehicle.states()
            ]
          ]}
        >
          <.input field={f.field} label={f.label} type={f.type} phx-debounce={120} {f.rest} />
        </.filter_fields>

        <button class="button" name="reset">reset</button>
      </.form>
    </div>
    """
  end
end
