defmodule RocketsizedWeb.RocketgridLive.Index do
  use RocketsizedWeb, :live_view

  alias Rocketsized.Rocket

  @impl Phoenix.LiveView
  def handle_params(params, _, socket) do
    case Rocket.list_vehicles_with_params(params) do
      {:ok, {rockets, meta, max_height}} ->
        {:noreply,
         socket
         |> stream(:rockets, rockets, reset: true)
         |> assign(%{meta: meta, max_height: max_height, page_title: "Launch vehicles list"})}

      {:error, _meta} ->
        {:noreply, push_navigate(socket, to: ~p"/")}
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
    {rockets, meta} = Rocket.list_vehicles_with_flop(flop)
    {:noreply, socket |> stream(:rockets, rockets) |> assign(:meta, meta)}
  end

  defp direction(_to = "next"), do: :next
  defp direction(_to = "previous"), do: :previous
end
