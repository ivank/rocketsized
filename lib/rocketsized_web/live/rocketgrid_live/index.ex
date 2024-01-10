defmodule RocketsizedWeb.RocketgridLive.Index do
  alias RocketsizedWeb.FilterParams
  use RocketsizedWeb, :live_view

  alias Rocketsized.Rocket
  alias Rocketsized.Rocket.Vehicle
  alias Rocketsized.Rocket.Vehicle.Image
  alias Rocketsized.Creator.Country.Flag
  alias Rocketsized.Creator.Manufacturer.Logo

  @impl Phoenix.LiveView
  def handle_params(params, _, socket) do
    case Flop.validate(FilterParams.load_params(params), for: Vehicle) do
      {:ok, flop} ->
        title = "Rockets " <> Rocket.flop_vehicles_title(flop, "of the world")

        {rockets, meta} = Rocket.flop_vehicles_grid(flop)
        max_height = Rocket.flop_vehicles_max_height(flop)

        {:noreply,
         socket
         |> stream(:rockets, rockets, reset: true)
         |> assign(%{meta: meta, max_height: max_height, page_title: title})}

      {:error, meta} ->
        {:noreply,
         socket
         |> stream(:rockets, [], reset: true)
         |> assign(%{meta: meta, max_height: 1, page_title: "Error"})}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("update-filter", params, socket) do
    params = Map.delete(params, "_target")
    {:noreply, push_patch(socket, to: ~p"/?#{params}")}
  end

  @impl Phoenix.LiveView
  def handle_event("paginate", %{"to" => to}, socket) do
    flop = Flop.set_cursor(socket.assigns.meta, direction(to))
    {rockets, meta} = Rocket.flop_vehicles_grid(flop)
    {:noreply, socket |> stream(:rockets, rockets) |> assign(:meta, meta)}
  end

  defp direction(_to = "next"), do: :next
  defp direction(_to = "previous"), do: :previous

  defp render_build_path(%Flop{} = flop, type) do
    Flop.Phoenix.build_path(
      &~p"/render/#{type}?#{FilterParams.dump_params(&1)}",
      %{flop | first: nil, last: nil} |> Flop.reset_order() |> Flop.reset_cursors()
    )
  end
end
