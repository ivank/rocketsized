defmodule RocketsizedWeb.RocketgridLive.FilterComponent do
  use RocketsizedWeb, :live_component

  alias Rocketsized.Rocket.Vehicle.Image
  alias Rocketsized.Creator.Country.Flag
  alias Rocketsized.Creator.Manufacturer.Logo
  alias RocketsizedWeb.FilterParams
  alias Rocketsized.Rocket

  attr :id, :string, default: nil
  attr :flop, Flop, required: true
  attr :class, :string, default: nil

  @impl true
  def render(assigns) do
    ~H"""
    <div class={@class}>
      <.label for={@id}>Filter by</.label>

      <input
        id={@id}
        type="text"
        class="mt-1 block w-full rounded-md border border-gray-300 bg-white shadow-sm focus:border-zinc-400 focus:ring-0 sm:text-sm"
        role="combobox"
        phx-debounce={120}
        phx-target={@myself}
        phx-keyup="search"
        aria-controls="options"
        phx-hook="combobox"
        phx-click-away="clear"
        aria-expanded="false"
        placeholder="China, Soyuz, Aerojet"
      />

      <div
        :if={not Enum.empty?(@options)}
        id={"#{@id}_options"}
        class="absolute z-10 mt-1 flex max-h-60 w-full flex-col overflow-auto rounded-md bg-white py-1 text-base shadow-lg ring-1 ring-black ring-opacity-5 sm:text-sm"
        role="listbox"
      >
        <.link
          :for={option <- @options}
          class="relative block py-2 pr-9 pl-3 text-left text-gray-900 focus:bg-indigo-600 focus:text-white focus:outline-none"
          role="option"
          tabindex="0"
          phx-click={JS.exec("data-hide", to: "#filter[data-shown]")}
          navigate={flop_build_path(FilterParams.add(@flop, option))}
        >
          <div class="flex flex-row items-center">
            <img
              :if={option.type == :rocket}
              src={Image.url({option.image, option})}
              class="h-8 w-8 -rotate-90 object-contain"
            />
            <img
              :if={option.type == :country}
              src={Flag.url({option.image, option})}
              class="h-8 w-8 object-contain"
            />
            <img
              :if={option.type == :org}
              src={Logo.url({option.image, option})}
              class="h-8 w-8 object-contain"
            />
            <div class="ml-3 truncate">
              <p class="truncate"><%= option.title %></p>
              <p :if={option.subtitle} class="truncate text-gray-400"><%= option.subtitle %></p>
            </div>
          </div>
        </.link>
      </div>

      <ul :if={not Enum.empty?(@items)} role="list" class="divide-y divide-gray-100">
        <li :for={item <- @items} class="flex items-center p-2 text-sm leading-6">
          <img
            :if={item.type == :rocket}
            src={Image.url({item.image, item})}
            class="h-8 w-8 -rotate-90 object-contain"
          />
          <img
            :if={item.type == :country}
            src={Flag.url({item.image, item})}
            class="h-8 w-8 object-contain"
          />
          <img
            :if={item.type == :org}
            src={Logo.url({item.image, item})}
            class="h-8 w-8 object-contain"
          />
          <div class="ml-3 flex-grow truncate">
            <p class="truncate"><%= item.title %></p>
            <p :if={item.subtitle} class="truncate text-gray-400"><%= item.subtitle %></p>
          </div>
          <div class="ml-4 space-x-4">
            <.link
              tabindex="0"
              navigate={flop_build_path(FilterParams.remove(@flop, item))}
              phx-click={JS.exec("data-hide", to: "#filter[data-shown]")}
              class="rounded-md bg-white font-medium text-gray-900 hover:text-gray-600"
            >
              <.icon name="hero-x-mark" />
            </.link>
          </div>
        </li>
      </ul>
    </div>
    """
  end

  def flop_build_path(%Flop{} = flop) do
    Flop.Phoenix.build_path(
      &~p"/?#{FilterParams.dump_params(&1)}",
      %{flop | first: nil, last: nil} |> Flop.reset_order() |> Flop.reset_cursors()
    )
  end

  @impl true
  def update(%{id: id, class: class, flop: %Flop{filters: filters} = flop}, socket) do
    items =
      case Flop.Filter.get_value(filters, :search) do
        [_ | _] = search -> Rocket.search_slugs(search)
        _ -> []
      end

    {:ok, socket |> assign(id: id, options: [], items: items, flop: flop, class: class)}
  end

  @impl true
  def handle_event("search", %{"value" => value}, socket) do
    {:noreply,
     socket
     |> assign(:options, Rocket.search_slugs_query(value))}
  end

  @impl true
  def handle_event("clear", _event, socket) do
    {:noreply, socket |> assign(options: [])}
  end
end
