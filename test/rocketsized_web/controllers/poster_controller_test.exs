defmodule RocketsizedWeb.PosterControllerTest do
  use RocketsizedWeb.ConnCase, async: true

  import Rocketsized.RocketFixtures
  import Rocketsized.CreatorFixtures

  setup do
    country = country_fixture()

    %{
      vehicles:
        for item <- 1..40 do
          vehicle_fixture(%{
            country_id: country.id,
            is_published: true,
            height: 100 - item,
            name: "rocket #{item}"
          })
        end
    }
  end

  describe "GET /poster.svg" do
    test "should show the poster", %{conn: conn, vehicles: vehicles} do
      conn = get(conn, ~p"/poster.svg")

      assert response_content_type(conn, :xml) =~ "image/svg+xml"

      body = response(conn, 200)

      for vehicle <- vehicles do
        assert body =~ vehicle.name
      end
    end
  end
end
