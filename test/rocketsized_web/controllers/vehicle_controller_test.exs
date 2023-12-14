defmodule RocketsizedWeb.VehicleControllerTest do
  use RocketsizedWeb.ConnCase

  import Rocketsized.RocketFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "index" do
    test "lists all vehicles", %{conn: conn} do
      conn = get(conn, ~p"/vehicles")
      assert html_response(conn, 200) =~ "Listing Vehicles"
    end
  end

  describe "new vehicle" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/vehicles/new")
      assert html_response(conn, 200) =~ "New Vehicle"
    end
  end

  describe "create vehicle" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/vehicles", vehicle: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/vehicles/#{id}"

      conn = get(conn, ~p"/vehicles/#{id}")
      assert html_response(conn, 200) =~ "Vehicle #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/vehicles", vehicle: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Vehicle"
    end
  end

  describe "edit vehicle" do
    setup [:create_vehicle]

    test "renders form for editing chosen vehicle", %{conn: conn, vehicle: vehicle} do
      conn = get(conn, ~p"/vehicles/#{vehicle}/edit")
      assert html_response(conn, 200) =~ "Edit Vehicle"
    end
  end

  describe "update vehicle" do
    setup [:create_vehicle]

    test "redirects when data is valid", %{conn: conn, vehicle: vehicle} do
      conn = put(conn, ~p"/vehicles/#{vehicle}", vehicle: @update_attrs)
      assert redirected_to(conn) == ~p"/vehicles/#{vehicle}"

      conn = get(conn, ~p"/vehicles/#{vehicle}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, vehicle: vehicle} do
      conn = put(conn, ~p"/vehicles/#{vehicle}", vehicle: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Vehicle"
    end
  end

  describe "delete vehicle" do
    setup [:create_vehicle]

    test "deletes chosen vehicle", %{conn: conn, vehicle: vehicle} do
      conn = delete(conn, ~p"/vehicles/#{vehicle}")
      assert redirected_to(conn) == ~p"/vehicles"

      assert_error_sent 404, fn ->
        get(conn, ~p"/vehicles/#{vehicle}")
      end
    end
  end

  defp create_vehicle(_) do
    vehicle = vehicle_fixture()
    %{vehicle: vehicle}
  end
end
