defmodule RocketsizedWeb.FormLive.ComboboxComponent do
  use RocketsizedWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
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
      />

      <div
        :if={not Enum.empty?(@options)}
        id={"#{@id}_options"}
        class="absolute z-10 mt-1 max-h-60 w-full overflow-auto rounded-md flex flex-col bg-white py-1 text-base shadow-lg ring-1 ring-black ring-opacity-5 sm:text-sm"
        role="listbox"
      >
        <button
          :for={option <- @options}
          class="relative text-left block py-2 pl-3 pr-9 text-gray-900 focus:text-white focus:outline-none focus:bg-indigo-600"
          role="option"
          name={@name}
          tabindex="0"
          value={"#{option.type}|#{option.id}"}
          type="submit"
        >
          <div class="flex flex-row items-center">
            <img
              :if={option.type == "vehicle"}
              src={Rocketsized.Rocket.Vehicle.Image.url({option.image, option}, signed: true)}
              class="rotate-90 w-8 h-8 object-contain"
            />
            <img
              :if={option.type == "country"}
              src={Rocketsized.Creator.Country.Flag.url({option.image, option}, signed: true)}
              class="w-8 h-8 object-contain"
            />
            <img
              :if={option.type == "manufacturer"}
              src={Rocketsized.Creator.Manufacturer.Logo.url({option.image, option}, signed: true)}
              class="w-8 h-8 object-contain"
            />
            <div class="ml-3 truncate">
              <p class="truncate"><%= option.name %></p>
              <p :if={option.sub} class="truncate text-gray-400"><%= option.sub %></p>
            </div>
          </div>
        </button>
      </div>

      <ul :if={not Enum.empty?(@items)} role="list" class="divide-y divide-gray-100">
        <li :for={item <- @items} class="flex items-center p-2 text-sm leading-6">
          <input
            type="hidden"
            value={"#{item.type}|#{item.id}"}
            name={@name}
            id={"#{@id}_#{item.type}_#{item.id}"}
          />
          <img
            :if={item.type == "vehicle"}
            src={Rocketsized.Rocket.Vehicle.Image.url({item.image, item}, signed: true)}
            class="rotate-90 w-8 h-8 object-contain"
          />
          <img
            :if={item.type == "country"}
            src={Rocketsized.Creator.Country.Flag.url({item.image, item}, signed: true)}
            class="w-8 h-8 object-contain"
          />
          <img
            :if={item.type == "manufacturer"}
            src={Rocketsized.Creator.Manufacturer.Logo.url({item.image, item}, signed: true)}
            class="w-8 h-8 object-contain"
          />
          <div class="ml-3 truncate flex-grow">
            <p class="truncate"><%= item.name %></p>
            <p :if={item.sub} class="truncate text-gray-400"><%= item.sub %></p>
          </div>
          <div class="ml-4 space-x-4">
            <button
              tabindex="0"
              type="submit"
              phx-click={JS.set_attribute({"disabled", true}, to: "##{@id}_#{item.type}_#{item.id}")}
              class="rounded-md bg-white font-medium text-gray-900 hover:text-gray-600"
            >
              <.icon name="hero-x-mark" />
            </button>
          </div>
        </li>
      </ul>
    </div>
    """
  end

  @impl true
  def update(%{id: id, value: value, name: name, search: search, to_options: to_options}, socket) do
    {:ok,
     socket
     |> assign(id: id, name: name, search: search, options: [])
     |> assign(items: if(value, do: to_options.(value), else: []))}
  end

  @impl true
  def handle_event("search", %{"value" => value}, %{assigns: %{search: search}} = socket) do
    {:noreply,
     socket
     |> assign(:options, search.(value))}
  end

  @impl true
  def handle_event("clear", _event, socket) do
    {:noreply, socket |> assign(options: [])}
  end
end
