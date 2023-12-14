defmodule RocketsizedWeb.CountryController do
  use RocketsizedWeb, :controller

  alias Rocketsized.Creator
  alias Rocketsized.Creator.Country

  def index(conn, _params) do
    countries = Creator.list_countries()
    render(conn, :index, countries: countries)
  end

  def new(conn, _params) do
    changeset = Creator.change_country(%Country{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"country" => country_params}) do
    case Creator.create_country(country_params) do
      {:ok, country} ->
        conn
        |> put_flash(:info, "Country created successfully.")
        |> redirect(to: ~p"/countries/#{country}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    country = Creator.get_country!(id)
    render(conn, :show, country: country)
  end

  def edit(conn, %{"id" => id}) do
    country = Creator.get_country!(id)
    changeset = Creator.change_country(country)
    render(conn, :edit, country: country, changeset: changeset)
  end

  def update(conn, %{"id" => id, "country" => country_params}) do
    country = Creator.get_country!(id)

    case Creator.update_country(country, country_params) do
      {:ok, country} ->
        conn
        |> put_flash(:info, "Country updated successfully.")
        |> redirect(to: ~p"/countries/#{country}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, country: country, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    country = Creator.get_country!(id)
    {:ok, _country} = Creator.delete_country(country)

    conn
    |> put_flash(:info, "Country deleted successfully.")
    |> redirect(to: ~p"/countries")
  end
end
