defmodule RocketsizedWeb.RocketgridLive.FilterComponent do
  alias Rocketsized.Rocket
  alias Rocketsized.Creator
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
        <.hidden_inputs_for_filter form={@form} />

        <.filter_fields
          :let={f}
          form={@form}
          fields={[
            id: [
              label: "Rockets",
              type: "combobox",
              op: :in,
              multiple: true,
              search: &Rocket.search_vehicles/1,
              to_options: &Rocket.list_vehicles_by_ids/1
            ],
            manufacturer_ids: [
              label: "Manufacturers",
              type: "combobox",
              op: :in,
              multiple: true,
              search: &Creator.search_manufacturers/1,
              to_options: &Creator.list_manufacturers_by_ids/1
            ],
            country_id: [
              label: "Countries",
              type: "combobox",
              op: :in,
              multiple: true,
              search: &Creator.search_countries/1,
              to_options: &Creator.list_countries_by_ids/1
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

        <button type="reset" class="button" name="reset">reset</button>
      </.form>
    </div>
    """
  end
end
