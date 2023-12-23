defmodule RocketsizedWeb.RocketgridLive.Index do
  use RocketsizedWeb, :live_view

  alias Rocketsized.Rocket

  @impl Phoenix.LiveView
  def handle_params(params, _, socket) do
    case Rocket.list_vehicles_with_params(params |> Map.put_new("page_size", 16)) do
      {:ok, {rockets, meta, max_height}} ->
        {:noreply,
         socket
         |> stream(:rockets, rockets, reset: true)
         |> assign(%{meta: meta, max_height: max_height})}

      {:error, _meta} ->
        # This will reset invalid parameters. Alternatively, you can assign
        # only the meta and render the errors, or you can ignore the error
        # case entirely.
        {:noreply, push_navigate(socket, to: ~p"/rocketgrid")}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("update-filter", params, socket) do
    params = Map.delete(params, "_target")
    {:noreply, push_patch(socket, to: ~p"/rocketgrid?#{params}")}
  end

  @impl Phoenix.LiveView
  def handle_event("next-page", _, socket) do
    flop = Flop.to_next_page(socket.assigns.meta.flop, socket.assigns.meta.total_pages)
    {rockets, meta} = Rocket.list_vehicles_with_flop(flop)
    {:noreply, socket |> stream(:rockets, rockets) |> assign(:meta, meta)}
  end

  @impl Phoenix.LiveView
  def handle_event("prev-page", _, socket) do
    flop = Flop.to_previous_page(socket.assigns.meta.flop)
    {rockets, meta} = Rocket.list_vehicles_with_flop(flop)
    {:noreply, socket |> stream(:rockets, rockets) |> assign(:meta, meta)}
  end
end
