defmodule RocketsizedWeb.Admin.RocketController do
  use RocketsizedWeb, :controller

  alias Rocketsized.Rocket
  alias Rocketsized.Rocket.Vehicle

  def index(conn, _params) do
    conn |> render(:index, resources: Rocket.list_vehicles())
  end

  def new(conn, _params) do
    conn |> render(:new, changeset: Rocket.change_vehicle(%Vehicle{}))
  end

  def create(conn, %{"resource" => params}) do
    case Rocket.create_vehicle(params) do
      {:ok, resource} ->
        conn
        |> put_flash(:info, "Vehicle created successfully.")
        |> redirect(to: ~p"/admin/rockets/#{resource}")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn |> render(:new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    render(conn, :show, resource: Rocket.get_vehicle!(id))
  end

  def edit(conn, %{"id" => id}) do
    resource = Rocket.get_vehicle!(id)
    changeset = Rocket.change_vehicle(resource)
    conn |> render(:edit, resource: resource, changeset: changeset)
  end

  def update(conn, %{"id" => id, "resource" => params}) do
    resource = Rocket.get_vehicle!(id)

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
