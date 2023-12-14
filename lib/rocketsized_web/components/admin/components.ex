defmodule RocketsizedWeb.Admin.Components do
  @moduledoc """
  Provides core Admin UI components.
  """
  use Phoenix.Component
  use Phoenix.VerifiedRoutes, endpoint: RocketsizedWeb.Endpoint, router: RocketsizedWeb.Router
  import RocketsizedWeb.CoreComponents

  attr :navigate, :string, required: true
  attr :active, :boolean, default: false
  attr :icon, :string, required: false
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def sidebar_link(assigns) do
    ~H"""
    <.link
      navigate={@navigate}
      class={[
        "group flex gap-x-3 rounded-md p-2 text-sm leading-6 font-semibold",
        if(@active,
          do: "bg-gray-50 text-indigo-600",
          else: "text-gray-700 hover:text-indigo-600 hover:bg-gray-50"
        ),
        @class
      ]}
      {@rest}
    >
      <.icon
        name={@icon}
        class={[
          "h-6 w-6 shrink-0",
          if(@active, do: "text-indigo-600", else: "text-gray-400 group-hover:text-indigo-600")
        ]}
      />

      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  def sidebar(assigns) do
    ~H"""
    <div class="flex h-16 shrink-0 items-center">
      <img
        class="h-8 w-auto"
        src="https://tailwindui.com/img/logos/mark.svg?color=indigo&shade=600"
        alt="Your Company"
      /> Rocketsized
    </div>
    <nav class="flex flex-1 flex-col">
      <ul role="list" class="-mx-2 space-y-1">
        <li>
          <.sidebar_link navigate={~p"/admin/rockets"} icon="hero-rocket-launch" active={true}>
            Rockets
          </.sidebar_link>
        </li>
      </ul>
    </nav>
    """
  end
end
