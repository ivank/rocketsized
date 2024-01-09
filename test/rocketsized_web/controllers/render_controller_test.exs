defmodule RocketsizedWeb.RenderControllerTest do
  use RocketsizedWeb.ConnCase, async: true

  import Rocketsized.RocketFixtures
  import Rocketsized.CreatorFixtures

  setup do
    country = country_fixture()
    manufacturer = manufacturer_fixture()

    %{
      vehicles:
        for item <- 1..40 do
          vehicle_fixture(%{
            country_id: country.id,
            vehicle_manufacturers: [%{manufacturer_id: manufacturer.id}],
            is_published: true,
            height: 100 - item,
            name: "rocket #{item}",
            slug: "r#{item}"
          })
        end
    }
  end

  describe "GET /render/:type" do
    test "should show the poster portrait", %{conn: conn, vehicles: vehicles} do
      for type <- ["portrait", "landscape", "wallpaper"] do
        conn = get(conn, ~p"/render/#{type}")

        assert response_content_type(conn, :xml) =~ "image/svg+xml"

        assert get_resp_header(conn, "content-disposition") |> Enum.at(0) =~ type

        body = response(conn, 200)

        for vehicle <- vehicles do
          assert body =~ vehicle.name
        end

        assert body =~ "Credit: AttribTest"
      end
    end
  end
end
