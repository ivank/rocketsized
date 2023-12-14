defmodule RocketsizedWeb.VehicleController do
  use RocketsizedWeb, :controller

  alias Rocketsized.Rocket
  alias Rocketsized.Rocket.Vehicle

  def index(conn, _params) do
    vehicles = Rocket.list_vehicles()
    render(conn, :index, vehicles: vehicles)
  end

  def new(conn, _params) do
    changeset = Rocket.change_vehicle(%Vehicle{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"vehicle" => vehicle_params}) do
    case Rocket.create_vehicle(vehicle_params) do
      {:ok, vehicle} ->
        conn
        |> put_flash(:info, "Vehicle created successfully.")
        |> redirect(to: ~p"/vehicles/#{vehicle}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    vehicle = Rocket.get_vehicle!(id)
    render(conn, :show, vehicle: vehicle)
  end

  def edit(conn, %{"id" => id}) do
    vehicle = Rocket.get_vehicle!(id)
    changeset = Rocket.change_vehicle(vehicle)
    render(conn, :edit, vehicle: vehicle, changeset: changeset)
  end

  def update(conn, %{"id" => id, "vehicle" => vehicle_params}) do
    vehicle = Rocket.get_vehicle!(id)

    case Rocket.update_vehicle(vehicle, vehicle_params) do
      {:ok, vehicle} ->
        conn
        |> put_flash(:info, "Vehicle updated successfully.")
        |> redirect(to: ~p"/vehicles/#{vehicle}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, vehicle: vehicle, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    vehicle = Rocket.get_vehicle!(id)
    {:ok, _vehicle} = Rocket.delete_vehicle(vehicle)

    conn
    |> put_flash(:info, "Vehicle deleted successfully.")
    |> redirect(to: ~p"/vehicles")
  end
end
