defmodule RocketsizedWeb.RocketgridLive.FilterComponent do
  alias Rocketsized.Rocket
  # alias Rocketsized.Creator
  use RocketsizedWeb, :live_component

  import Flop.Phoenix

  attr :meta, Flop.Meta, required: true
  attr :id, :string, default: nil
  attr :on_change, :string
  attr :on_reset, :string
  attr :target, :string, default: nil

  @impl true
  def render(%{meta: meta} = assigns) do
    assigns = assign(assigns, form: Phoenix.Component.to_form(meta), meta: nil)

    ~H"""
    <div class="py- flex flex-col gap-4">
      <.form for={@form} id={@id} phx-target={@target} phx-change={@on_change} phx-submit={@on_change}>
        <.filter_fields
          :let={f}
          form={@form}
          fields={[
            search: [
              label: "Filter by",
              type: "combobox",
              op: :in,
              multiple: true,
              search: &Rocket.list_vehicle_filters_by_query/1,
              to_options: &Rocket.list_vehicle_filters_by_ids/1
            ]
          ]}
        >
          <.input field={f.field} label={f.label} type={f.type} phx-debounce={120} {f.rest} />
        </.filter_fields>
      </.form>
    </div>
    """
  end
end
