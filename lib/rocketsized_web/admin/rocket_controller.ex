defmodule RocketsizedWeb.Admin.RocketController do
  use RocketsizedWeb, :controller

  alias Rocketsized.Rocket
  alias Rocketsized.Rocket.Vehicle
  alias Rocketsized.Creator

  def index(conn, _params) do
    conn |> render(:index, resources: Rocket.list_vehicles_admin())
  end

  def new(conn, _params) do
    conn
    |> render(:new,
      changeset: Rocket.change_vehicle(%Vehicle{}),
      countries: Creator.list_countries(),
      manufacturers: Creator.list_manufacturers()
    )
  end

  def create(conn, %{"resource" => params}) do
    case Rocket.create_vehicle(params) do
      {:ok, resource} ->
        conn
        |> put_flash(:info, "Vehicle created successfully.")
        |> redirect(to: ~p"/admin/rockets/#{resource}")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render(:new,
          changeset: changeset,
          countries: Creator.list_countries(),
          manufacturers: Creator.list_manufacturers()
        )
    end
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    render(conn, :show, resource: Rocket.get_vehicle_with_data!(id))
  end

  def edit(conn, %{"id" => id}) do
    resource = Rocket.get_vehicle_with_data!(id)
    changeset = Rocket.change_vehicle(resource)

    conn
    |> render(:edit,
      resource: resource,
      changeset: changeset,
      countries: Creator.list_countries(),
      manufacturers: Creator.list_manufacturers()
    )
  end

  def update(conn, %{"id" => id, "resource" => params}) do
    resource = Rocket.get_vehicle_with_data!(id)

    case Rocket.update_vehicle(resource, params) do
      {:ok, resource} ->
        conn
        |> put_flash(:info, "Vehicle updated successfully.")
        |> redirect(to: ~p"/admin/rockets/#{resource}")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn |> render(:edit, resource: resource, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    resource = Rocket.get_vehicle!(id)
    {:ok, _vehicle} = Rocket.delete_vehicle(resource)

    conn
    |> put_flash(:info, "Vehicle deleted successfully.")
    |> redirect(to: ~p"/admin/rockets")
  end
end
