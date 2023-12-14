defmodule RocketsizedWeb.FamilyController do
  use RocketsizedWeb, :controller

  alias Rocketsized.Rocket
  alias Rocketsized.Rocket.Family

  def index(conn, _params) do
    families = Rocket.list_families()
    render(conn, :index, families: families)
  end

  def new(conn, _params) do
    changeset = Rocket.change_family(%Family{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"family" => family_params}) do
    case Rocket.create_family(family_params) do
      {:ok, family} ->
        conn
        |> put_flash(:info, "Family created successfully.")
        |> redirect(to: ~p"/families/#{family}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    family = Rocket.get_family!(id)
    render(conn, :show, family: family)
  end

  def edit(conn, %{"id" => id}) do
    family = Rocket.get_family!(id)
    changeset = Rocket.change_family(family)
    render(conn, :edit, family: family, changeset: changeset)
  end

  def update(conn, %{"id" => id, "family" => family_params}) do
    family = Rocket.get_family!(id)

    case Rocket.update_family(family, family_params) do
      {:ok, family} ->
        conn
        |> put_flash(:info, "Family updated successfully.")
        |> redirect(to: ~p"/families/#{family}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, family: family, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    family = Rocket.get_family!(id)
    {:ok, _family} = Rocket.delete_family(family)

    conn
    |> put_flash(:info, "Family deleted successfully.")
    |> redirect(to: ~p"/families")
  end
end
