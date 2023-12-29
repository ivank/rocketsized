defmodule RocketsizedWeb.Admin.TasksLive.Index do
  use RocketsizedWeb, :live_view
  alias Rocketsized.Rocket
  import RocketsizedWeb.Admin.Components

  @impl Phoenix.LiveView
  def handle_params(_, _, socket) do
    {:noreply, socket |> stream(:rockets, Rocket.list_vehicles_image_meta())}
  end

  @impl Phoenix.LiveView
  def handle_event("update", %{"id" => id}, socket) do
    case Rocket.get_vehicle!(String.to_integer(id)) |> Rocket.put_new_vehicle_image_meta() do
      {:ok, rocket} ->
        {:noreply, socket |> stream_insert(:rockets, rocket)}

      {:error, _changeset} ->
        {:noreply, socket |> put_flash(:error, "Error updating image info.")}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("update-all", _, socket) do
    for rocket <- Rocket.list_vehicles_image_meta_missing() do
      case rocket |> Rocket.put_new_vehicle_image_meta() do
        {:ok, rocket} ->
          send(self(), {:update_rocket, rocket})
          rocket

        {:error, changeset} ->
          changeset
      end
    end

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info({:update_rocket, rocket}, socket) do
    {:noreply, socket |> stream_insert(:rockets, rocket)}
  end
end
