defmodule RocketsizedWeb.MotorController do
  use RocketsizedWeb, :controller

  alias Rocketsized.Rocket
  alias Rocketsized.Rocket.Motor

  def index(conn, _params) do
    motors = Rocket.list_motors()
    render(conn, :index, motors: motors)
  end

  def new(conn, _params) do
    changeset = Rocket.change_motor(%Motor{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"motor" => motor_params}) do
    case Rocket.create_motor(motor_params) do
      {:ok, motor} ->
        conn
        |> put_flash(:info, "Motor created successfully.")
        |> redirect(to: ~p"/motors/#{motor}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    motor = Rocket.get_motor!(id)
    render(conn, :show, motor: motor)
  end

  def edit(conn, %{"id" => id}) do
    motor = Rocket.get_motor!(id)
    changeset = Rocket.change_motor(motor)
    render(conn, :edit, motor: motor, changeset: changeset)
  end

  def update(conn, %{"id" => id, "motor" => motor_params}) do
    motor = Rocket.get_motor!(id)

    case Rocket.update_motor(motor, motor_params) do
      {:ok, motor} ->
        conn
        |> put_flash(:info, "Motor updated successfully.")
        |> redirect(to: ~p"/motors/#{motor}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, motor: motor, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    motor = Rocket.get_motor!(id)
    {:ok, _motor} = Rocket.delete_motor(motor)

    conn
    |> put_flash(:info, "Motor deleted successfully.")
    |> redirect(to: ~p"/motors")
  end
end
