defmodule RocketsizedWeb.ManufacturerController do
  use RocketsizedWeb, :controller

  alias Rocketsized.Creator
  alias Rocketsized.Creator.Manufacturer

  def index(conn, _params) do
    manufacturers = Creator.list_manufacturers()
    render(conn, :index, manufacturers: manufacturers)
  end

  def new(conn, _params) do
    changeset = Creator.change_manufacturer(%Manufacturer{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"manufacturer" => manufacturer_params}) do
    case Creator.create_manufacturer(manufacturer_params) do
      {:ok, manufacturer} ->
        conn
        |> put_flash(:info, "Manufacturer created successfully.")
        |> redirect(to: ~p"/manufacturers/#{manufacturer}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    manufacturer = Creator.get_manufacturer!(id)
    render(conn, :show, manufacturer: manufacturer)
  end

  def edit(conn, %{"id" => id}) do
    manufacturer = Creator.get_manufacturer!(id)
    changeset = Creator.change_manufacturer(manufacturer)
    render(conn, :edit, manufacturer: manufacturer, changeset: changeset)
  end

  def update(conn, %{"id" => id, "manufacturer" => manufacturer_params}) do
    manufacturer = Creator.get_manufacturer!(id)

    case Creator.update_manufacturer(manufacturer, manufacturer_params) do
      {:ok, manufacturer} ->
        conn
        |> put_flash(:info, "Manufacturer updated successfully.")
        |> redirect(to: ~p"/manufacturers/#{manufacturer}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, manufacturer: manufacturer, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    manufacturer = Creator.get_manufacturer!(id)
    {:ok, _manufacturer} = Creator.delete_manufacturer(manufacturer)

    conn
    |> put_flash(:info, "Manufacturer deleted successfully.")
    |> redirect(to: ~p"/manufacturers")
  end
end
