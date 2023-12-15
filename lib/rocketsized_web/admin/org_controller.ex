defmodule RocketsizedWeb.Admin.OrgController do
  use RocketsizedWeb, :controller

  alias Rocketsized.Creator
  alias Rocketsized.Creator.Manufacturer

  def index(conn, _params) do
    conn |> render(:index, resources: Creator.list_manufacturers())
  end

  def new(conn, _params) do
    conn |> render(:new, changeset: Creator.change_manufacturer(%Manufacturer{}))
  end

  def create(conn, %{"resource" => params}) do
    case Creator.create_manufacturer(params) do
      {:ok, resource} ->
        conn
        |> put_flash(:info, "Organization created successfully.")
        |> redirect(to: ~p"/admin/orgs/#{resource}")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn |> render(:new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    render(conn, :show, resource: Creator.get_manufacturer_with_vehicles!(id))
  end

  def edit(conn, %{"id" => id}) do
    resource = Creator.get_manufacturer!(id)
    changeset = Creator.change_manufacturer(resource)
    conn |> render(:edit, resource: resource, changeset: changeset)
  end

  def update(conn, %{"id" => id, "resource" => params}) do
    resource = Creator.get_manufacturer!(id)

    case Creator.update_manufacturer(resource, params) do
      {:ok, resource} ->
        conn
        |> put_flash(:info, "Organization updated successfully.")
        |> redirect(to: ~p"/admin/orgs/#{resource}")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn |> render(:edit, resource: resource, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    resource = Creator.get_manufacturer!(id)
    {:ok, _manufacturer} = Creator.delete_manufacturer(resource)

    conn
    |> put_flash(:info, "Organization deleted successfully.")
    |> redirect(to: ~p"/admin/orgs")
  end
end
