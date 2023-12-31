defmodule RocketsizedWeb.RocketgridLiveTest do
  use RocketsizedWeb.ConnCase

  import Phoenix.LiveViewTest
  import Rocketsized.RocketFixtures
  import Rocketsized.CreatorFixtures

  defp create_vehicle(_) do
    country = country_fixture()

    vehicles =
      for item <- 1..40 do
        vehicle_fixture(%{
          country_id: country.id,
          is_published: true,
          height: 100 - item,
          name: "rocket #{item}"
        })
      end

    %{vehicles: vehicles, country: country}
  end

  describe "Rocketgrid view" do
    setup [:create_vehicle]

    test "render rocket list", %{conn: conn, vehicles: vehicles, country: country} do
      {:ok, _view, html} = conn |> live(~p"/")

      {page, outside} = Enum.split(vehicles, 32)

      for vehicle <- page do
        assert html =~ vehicle.name
        assert html =~ vehicle.alternative_name
        assert html =~ vehicle.native_name
        assert html =~ country.name
      end

      for vehicle <- outside do
        refute html =~ vehicle.name
      end
    end

    test "render paginate", %{conn: conn, vehicles: vehicles, country: country} do
      {:ok, view, _html} = conn |> live(~p"/")

      html = view |> render_hook("paginate", %{"to" => "next"})

      for vehicle <- vehicles do
        assert html =~ vehicle.name
        assert html =~ vehicle.alternative_name
        assert html =~ vehicle.native_name
        assert html =~ country.name
      end
    end

    test "rocket filter by vehicle id", %{conn: conn, vehicles: vehicles} do
      {:ok, view, _html} = conn |> live(~p"/")

      assert page_title(view) =~ "Launch vehicles list"

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

      assert page_title(view) =~ v.name
      assert view |> has_element?("ul[role=list] > li", v.name)
      refute view |> has_element?("ul[role=list] > li", filtered_out_v.name)

      view
      |> element("#filter-form")
      |> render_submit(%{"filters" => %{0 => %{"field" => "search", "op" => "in", "value" => []}}})

      assert page_title(view) =~ "Launch vehicles list"
    end
  end
end
