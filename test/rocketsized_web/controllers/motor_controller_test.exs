defmodule RocketsizedWeb.MotorControllerTest do
  use RocketsizedWeb.ConnCase

  import Rocketsized.RocketFixtures

  @create_attrs %{
    cycle: :gas_generator,
    isp_space: 120.5,
    isp_sea: 120.5,
    thrust: 120.5,
    chamber_pressure: 120.5,
    weight: 120.5
  }
  @update_attrs %{
    cycle: :full_flow_staged_combustion,
    isp_space: 456.7,
    isp_sea: 456.7,
    thrust: 456.7,
    chamber_pressure: 456.7,
    weight: 456.7
  }
  @invalid_attrs %{
    cycle: nil,
    isp_space: nil,
    isp_sea: nil,
    thrust: nil,
    chamber_pressure: nil,
    weight: nil
  }

  describe "index" do
    test "lists all motors", %{conn: conn} do
      conn = get(conn, ~p"/motors")
      assert html_response(conn, 200) =~ "Listing Motors"
    end
  end

  describe "new motor" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/motors/new")
      assert html_response(conn, 200) =~ "New Motor"
    end
  end

  describe "create motor" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/motors", motor: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/motors/#{id}"

      conn = get(conn, ~p"/motors/#{id}")
      assert html_response(conn, 200) =~ "Motor #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/motors", motor: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Motor"
    end
  end

  describe "edit motor" do
    setup [:create_motor]

    test "renders form for editing chosen motor", %{conn: conn, motor: motor} do
      conn = get(conn, ~p"/motors/#{motor}/edit")
      assert html_response(conn, 200) =~ "Edit Motor"
    end
  end

  describe "update motor" do
    setup [:create_motor]

    test "redirects when data is valid", %{conn: conn, motor: motor} do
      conn = put(conn, ~p"/motors/#{motor}", motor: @update_attrs)
      assert redirected_to(conn) == ~p"/motors/#{motor}"

      conn = get(conn, ~p"/motors/#{motor}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, motor: motor} do
      conn = put(conn, ~p"/motors/#{motor}", motor: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Motor"
    end
  end

  describe "delete motor" do
    setup [:create_motor]

    test "deletes chosen motor", %{conn: conn, motor: motor} do
      conn = delete(conn, ~p"/motors/#{motor}")
      assert redirected_to(conn) == ~p"/motors"

      assert_error_sent 404, fn ->
        get(conn, ~p"/motors/#{motor}")
      end
    end
  end

  defp create_motor(_) do
    motor = motor_fixture()
    %{motor: motor}
  end
end
