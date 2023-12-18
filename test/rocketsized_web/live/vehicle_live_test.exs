defmodule RocketsizedWeb.VehicleLiveTest do
  use RocketsizedWeb.ConnCase

  import Phoenix.LiveViewTest
  import Rocketsized.RocketsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_vehicle(_) do
    vehicle = vehicle_fixture()
    %{vehicle: vehicle}
  end

  describe "Index" do
    setup [:create_vehicle]

    test "lists all vehicles", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/vehicles")

      assert html =~ "Listing Vehicles"
    end

    test "saves new vehicle", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/vehicles")

      assert index_live |> element("a", "New Vehicle") |> render_click() =~
               "New Vehicle"

      assert_patch(index_live, ~p"/vehicles/new")

      assert index_live
             |> form("#vehicle-form", vehicle: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#vehicle-form", vehicle: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/vehicles")

      html = render(index_live)
      assert html =~ "Vehicle created successfully"
    end

    test "updates vehicle in listing", %{conn: conn, vehicle: vehicle} do
      {:ok, index_live, _html} = live(conn, ~p"/vehicles")

      assert index_live |> element("#vehicles-#{vehicle.id} a", "Edit") |> render_click() =~
               "Edit Vehicle"

      assert_patch(index_live, ~p"/vehicles/#{vehicle}/edit")

      assert index_live
             |> form("#vehicle-form", vehicle: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#vehicle-form", vehicle: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/vehicles")

      html = render(index_live)
      assert html =~ "Vehicle updated successfully"
    end

    test "deletes vehicle in listing", %{conn: conn, vehicle: vehicle} do
      {:ok, index_live, _html} = live(conn, ~p"/vehicles")

      assert index_live |> element("#vehicles-#{vehicle.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#vehicles-#{vehicle.id}")
    end
  end

  describe "Show" do
    setup [:create_vehicle]

    test "displays vehicle", %{conn: conn, vehicle: vehicle} do
      {:ok, _show_live, html} = live(conn, ~p"/vehicles/#{vehicle}")

      assert html =~ "Show Vehicle"
    end

    test "updates vehicle within modal", %{conn: conn, vehicle: vehicle} do
      {:ok, show_live, _html} = live(conn, ~p"/vehicles/#{vehicle}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Vehicle"

      assert_patch(show_live, ~p"/vehicles/#{vehicle}/show/edit")

      assert show_live
             |> form("#vehicle-form", vehicle: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#vehicle-form", vehicle: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/vehicles/#{vehicle}")

      html = render(show_live)
      assert html =~ "Vehicle updated successfully"
    end
  end
end
