defmodule RocketsizedWeb.Admin.CountryController do
  use RocketsizedWeb, :controller

  alias Rocketsized.Creator
  alias Rocketsized.Creator.Country

  def index(conn, _params) do
    conn |> render(:index, resources: Creator.list_countries())
  end

  def new(conn, _params) do
    conn |> render(:new, changeset: Creator.change_country(%Country{}))
  end

  def create(conn, %{"resource" => params}) do
    case Creator.create_country(params |> Map.update("flag", nil, &File.read!(&1.path))) do
      {:ok, resource} ->
        conn
        |> put_flash(:info, "Country created successfully.")
        |> redirect(to: ~p"/admin/countries/#{resource}")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn |> render(:new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    conn |> render(:show, resource: Creator.get_country_with_vehicles!(id))
  end

  def edit(conn, %{"id" => id}) do
    resource = Creator.get_country!(id)
    changeset = Creator.change_country(resource)
    conn |> render(:edit, resource: resource, changeset: changeset)
  end

  def update(conn, %{"id" => id, "resource" => params}) do
    resource = Creator.get_country!(id)

    case Creator.update_country(
           resource,
           params |> Map.update("flag", resource.flag, &File.read!(&1.path))
         ) do
      {:ok, resource} ->
        conn
        |> put_flash(:info, "Country updated successfully.")
        |> redirect(to: ~p"/admin/countries/#{resource}")

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        conn |> render(:edit, resource: resource, changeset: changeset)
    end
  end

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    resource = Creator.get_country!(id)
    {:ok, _resource} = Creator.delete_country(resource)

    conn
    |> put_flash(:info, "Country #{resource.name} successfully.")
    |> redirect(to: ~p"/admin/countries")
  end
end
