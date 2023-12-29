defmodule RocketsizedWeb.Admin.Components do
  @moduledoc """
  Provides core Admin UI components.
  """
  use Phoenix.Component
  use Phoenix.VerifiedRoutes, endpoint: RocketsizedWeb.Endpoint, router: RocketsizedWeb.Router
  import RocketsizedWeb.CoreComponents

  slot :actions

  slot :breadcrumb do
    attr :navigate, :string, required: true
  end

  slot :inner_block, required: true

  def admin_header(assigns) do
    ~H"""
    <header>
      <div>
        <nav :if={length(@breadcrumb) > 0} class="sm:hidden" aria-label="Back">
          <.link
            navigate={List.last(@breadcrumb)[:navigate]}
            class="flex items-center text-sm font-medium text-gray-500 hover:text-gray-700"
          >
            <.icon name="hero-chevron-left" class="-ml-1 mr-1 h-5 w-5 flex-shrink-0 text-gray-400" />
            Back
          </.link>
        </nav>
        <nav :if={length(@breadcrumb) > 0} class="hidden sm:flex" aria-label="Breadcrumb">
          <ol role="list" class="flex items-center space-x-4">
            <li>
              <div class="flex">
                <.link
                  navigate={hd(@breadcrumb)[:navigate]}
                  class="text-sm font-medium text-gray-500 hover:text-gray-700"
                >
                  <%= render_slot(hd(@breadcrumb)) %>
                </.link>
              </div>
            </li>
            <li :for={breadcrumb <- tl(@breadcrumb)}>
              <div class="flex items-center">
                <.icon name="hero-chevron-right" class="h-5 w-5 flex-shrink-0 text-gray-400" />
                <.link
                  navigate={breadcrumb[:navigate]}
                  class="ml-4 text-sm font-medium text-gray-500 hover:text-gray-700"
                >
                  <%= render_slot(breadcrumb) %>
                </.link>
              </div>
            </li>
          </ol>
        </nav>
      </div>
      <div class="mt-2 md:flex md:items-center md:justify-between">
        <div class="min-w-0 flex-1">
          <h2 class="text-2xl font-bold leading-7 text-gray-900 sm:truncate sm:text-3xl sm:tracking-tight">
            <%= render_slot(@inner_block) %>
          </h2>
        </div>
        <div :if={@actions != []} class="mt-4 flex flex-shrink-0 md:mt-0 md:ml-4">
          <%= render_slot(@actions) %>
        </div>
      </div>
    </header>
    """
  end

  attr :navigate, :string, required: true
  attr :icon, :string, required: false
  attr :class, :string, default: nil
  attr :active, :boolean, default: false
  attr :rest, :global

  slot :inner_block, required: true

  def sidebar_link(assigns) do
    ~H"""
    <.link
      navigate={@navigate}
      class={[
        "group flex gap-x-3 rounded-md p-2 text-sm leading-6 font-semibold",
        if(@active,
          do: "bg-gray-50 text-orange-600",
          else: "text-gray-700 hover:text-orange-600 hover:bg-gray-50"
        ),
        @class
      ]}
      {@rest}
    >
      <.icon
        name={@icon}
        class={[
          "h-6 w-6 shrink-0",
          if(@active, do: "text-orange-600", else: "text-gray-400 group-hover:text-orange-600")
        ]}
      />

      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  def sidebar(assigns) do
    ~H"""
    <div class="flex h-16 shrink-0 items-center gap-2">
      <img class="h-8 w-auto" src="/images/logo.svg" alt="Rocketsized Logo" />
      <h1 class="text-2xl font-bold">Admin</h1>
    </div>
    <nav class="flex flex-1 flex-col">
      <ul role="list" class="-mx-2 space-y-1">
        <li>
          <.sidebar_link navigate={~p"/admin/rockets"} icon="hero-rocket-launch">
            Rockets
          </.sidebar_link>
          <.sidebar_link navigate={~p"/admin/orgs"} icon="hero-building-office-2">
            Organizations
          </.sidebar_link>
          <.sidebar_link navigate={~p"/admin/countries"} icon="hero-globe-alt">
            Countries
          </.sidebar_link>
          <.sidebar_link navigate={~p"/admin/tasks"} icon="hero-wrench-screwdriver">
            Tasks
          </.sidebar_link>
        </li>
      </ul>
    </nav>
    """
  end
end
