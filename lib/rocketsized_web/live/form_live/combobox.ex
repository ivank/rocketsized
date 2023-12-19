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
        aria-expanded="false"
      />

      <div
        :if={not Enum.empty?(@options)}
        id={"#{@id}_options"}
        class="absolute z-10 mt-1 max-h-60 w-full overflow-auto rounded-md flex flex-col bg-white py-1 text-base shadow-lg ring-1 ring-black ring-opacity-5 sm:text-sm"
        role="listbox"
      >
        <button
          :for={{id, value} <- @options}
          class="relative text-left block py-2 pl-3 pr-9 text-gray-900 focus:text-white focus:outline-none focus:bg-indigo-600"
          role="option"
          name={@name}
          tabindex="0"
          value={id}
          type="submit"
        >
          <span class="truncate"><%= value %></span>
        </button>
      </div>

      <ul
        :if={not Enum.empty?(@items)}
        role="list"
        class="divide-y divide-gray-100 rounded-md border border-gray-200"
      >
        <li
          :for={{id, item} <- @items}
          class="flex items-center justify-between py-4 pl-4 pr-5 text-sm leading-6"
        >
          <input type="hidden" value={id} name={@name} id={"#{@id}_#{id}"} />
          <div class="flex w-0 flex-1 items-center">
            <%= item %>
          </div>
          <div class="ml-4 flex flex-shrink-0 space-x-4">
            <button
              tabindex="0"
              type="submit"
              phx-click={JS.set_attribute({"disabled", true}, to: "##{@id}_#{id}")}
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
end
