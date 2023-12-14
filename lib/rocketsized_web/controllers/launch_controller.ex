defmodule RocketsizedWeb.LaunchController do
  use RocketsizedWeb, :controller

  alias Rocketsized.Rocket
  alias Rocketsized.Rocket.Launch

  def index(conn, _params) do
    launches = Rocket.list_launches()
    render(conn, :index, launches: launches)
  end

  def new(conn, _params) do
    changeset = Rocket.change_launch(%Launch{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"launch" => launch_params}) do
    case Rocket.create_launch(launch_params) do
      {:ok, launch} ->
        conn
        |> put_flash(:info, "Launch created successfully.")
        |> redirect(to: ~p"/launches/#{launch}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    launch = Rocket.get_launch!(id)
    render(conn, :show, launch: launch)
  end

  def edit(conn, %{"id" => id}) do
    launch = Rocket.get_launch!(id)
    changeset = Rocket.change_launch(launch)
    render(conn, :edit, launch: launch, changeset: changeset)
  end

  def update(conn, %{"id" => id, "launch" => launch_params}) do
    launch = Rocket.get_launch!(id)

    case Rocket.update_launch(launch, launch_params) do
      {:ok, launch} ->
        conn
        |> put_flash(:info, "Launch updated successfully.")
        |> redirect(to: ~p"/launches/#{launch}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, launch: launch, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    launch = Rocket.get_launch!(id)
    {:ok, _launch} = Rocket.delete_launch(launch)

    conn
    |> put_flash(:info, "Launch deleted successfully.")
    |> redirect(to: ~p"/launches")
  end
end
