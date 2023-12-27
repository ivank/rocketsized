defmodule RocketsizedWeb.RocketgridLiveTest do
  use RocketsizedWeb.ConnCase

  import Phoenix.LiveViewTest
  import Rocketsized.RocketFixtures
  import Rocketsized.CreatorFixtures

  defp create_vehicle(_) do
    country = country_fixture()

    vehicles = [
      vehicle_fixture(%{country_id: country.id, is_published: true, name: "big thing"}),
      vehicle_fixture(%{country_id: country.id, is_published: true, name: "other rocket"})
    ]

    %{vehicles: vehicles, country: country}
  end

  describe "Rocketgrid view" do
    setup [:create_vehicle]

    test "render rocket list", %{conn: conn, vehicles: vehicles, country: country} do
      {:ok, _lv, html} = conn |> live(~p"/")

      for vehicle <- vehicles do
        assert html =~ vehicle.name
        assert html =~ vehicle.alternative_name
        assert html =~ vehicle.native_name
        assert html =~ country.name
      end
    end

    test "rocket filter by vehicle id", %{conn: conn, vehicles: vehicles} do
      {:ok, view, _html} = conn |> live(~p"/")

      v = List.last(vehicles)
      filtered_out_v = List.first(vehicles)

      assert view |> render =~ filtered_out_v.name
      refute view |> has_element?("ul[role=list] > li", v.name)

      view |> element("#flop_filters_0_value") |> render_keyup(%{"value" => v.name})

      assert view |> has_element?("#flop_filters_0_value_options > button", v.name)

      view
      |> element("#filter-form")
      |> render_submit(%{
        "filters" => %{0 => %{"field" => "search", "op" => "in", "value" => ["vehicle_#{v.id}"]}}
      })

      assert view |> has_element?("ul[role=list] > li", v.name)
    end
  end
end