defmodule RocketsizedWeb.RocketgridLiveTest do
  use RocketsizedWeb.ConnCase

  import Phoenix.LiveViewTest
  import Rocketsized.RocketFixtures
  import Rocketsized.CreatorFixtures

  alias RocketsizedWeb.RocketgridLive.FilterComponent

  defp create_vehicle(_) do
    country = country_fixture()
    manufacturer = manufacturer_fixture()

    vehicles =
      for item <- 1..40 do
        vehicle_fixture(%{
          country_id: country.id,
          is_published: true,
          vehicle_manufacturers: [%{manufacturer_id: manufacturer.id}],
          height: 100 - item,
          name: "rocket #{item}",
          slug: "r#{item}"
        })
      end

    %{vehicles: vehicles, country: country}
  end

  describe "Rocketgrid view" do
    setup [:create_vehicle]

    test "render rocket list", %{conn: conn, vehicles: vehicles, country: country} do
      {:ok, _view, html} = conn |> live(~p"/")

      {page, outside} = Enum.split(vehicles, 24)

      for vehicle <- page do
        assert html =~ vehicle.name
        assert html =~ vehicle.alternative_name
        assert html =~ vehicle.native_name
        assert html =~ country.name
        assert html =~ vehicle.image_meta.attribution
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

      assert page_title(view) =~ "Rockets of the world"

      v = List.last(vehicles)
      filtered_out_v = List.first(vehicles)

      assert view |> render =~ filtered_out_v.name
      refute view |> has_element?("ul[role=list] > li", v.name)

      view |> element("#filter-form") |> render_keyup(%{"value" => v.name})

      assert view |> has_element?("#filter-form_options > a", v.name)
    end
  end

  describe "filter-form" do
    test "flop_build_path/1" do
      paths = [
        {["c_ca"], "/?country[]=ca"},
        {["r_fh", "r_f9"], "/?rocket[]=fh&rocket[]=f9"},
        {["o_spacex"], "/?org[]=spacex"},
        {["r_fh", "r_f9", "o_spacex"], "/?org[]=spacex&rocket[]=fh&rocket[]=f9"},
        {["c_ca", "o_spacex"], "/?country[]=ca&org[]=spacex"},
        {["c_ca", "r_fh", "r_f9"], "/?country[]=ca&rocket[]=fh&rocket[]=f9"},
        {["c_ca", "r_fh", "r_f9", "o_spacex"],
         "/?country[]=ca&org[]=spacex&rocket[]=fh&rocket[]=f9"}
      ]

      for {search, expected} <- paths do
        flop = %Flop{filters: [] |> Flop.Filter.put_value(:search, search), first: 24}
        assert FilterComponent.flop_build_path(flop) == expected
      end
    end
  end
end
