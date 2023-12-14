defmodule RocketsizedWeb.StageController do
  use RocketsizedWeb, :controller

  alias Rocketsized.Rocket
  alias Rocketsized.Rocket.Stage

  def index(conn, _params) do
    stages = Rocket.list_stages()
    render(conn, :index, stages: stages)
  end

  def new(conn, _params) do
    changeset = Rocket.change_stage(%Stage{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"stage" => stage_params}) do
    case Rocket.create_stage(stage_params) do
      {:ok, stage} ->
        conn
        |> put_flash(:info, "Stage created successfully.")
        |> redirect(to: ~p"/stages/#{stage}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    stage = Rocket.get_stage!(id)
    render(conn, :show, stage: stage)
  end

  def edit(conn, %{"id" => id}) do
    stage = Rocket.get_stage!(id)
    changeset = Rocket.change_stage(stage)
    render(conn, :edit, stage: stage, changeset: changeset)
  end

  def update(conn, %{"id" => id, "stage" => stage_params}) do
    stage = Rocket.get_stage!(id)

    case Rocket.update_stage(stage, stage_params) do
      {:ok, stage} ->
        conn
        |> put_flash(:info, "Stage updated successfully.")
        |> redirect(to: ~p"/stages/#{stage}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, stage: stage, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    stage = Rocket.get_stage!(id)
    {:ok, _stage} = Rocket.delete_stage(stage)

    conn
    |> put_flash(:info, "Stage deleted successfully.")
    |> redirect(to: ~p"/stages")
  end
end
