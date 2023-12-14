defmodule RocketsizedWeb.CountryControllerTest do
  use RocketsizedWeb.ConnCase

  import Rocketsized.CreatorFixtures

  @create_attrs %{name: "some name", flag: "some flag"}
  @update_attrs %{name: "some updated name", flag: "some updated flag"}
  @invalid_attrs %{name: nil, flag: nil}

  describe "index" do
    test "lists all countries", %{conn: conn} do
      conn = get(conn, ~p"/countries")
      assert html_response(conn, 200) =~ "Listing Countries"
    end
  end

  describe "new country" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/countries/new")
      assert html_response(conn, 200) =~ "New Country"
    end
  end

  describe "create country" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/countries", country: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/countries/#{id}"

      conn = get(conn, ~p"/countries/#{id}")
      assert html_response(conn, 200) =~ "Country #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/countries", country: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Country"
    end
  end

  describe "edit country" do
    setup [:create_country]

    test "renders form for editing chosen country", %{conn: conn, country: country} do
      conn = get(conn, ~p"/countries/#{country}/edit")
      assert html_response(conn, 200) =~ "Edit Country"
    end
  end

  describe "update country" do
    setup [:create_country]

    test "redirects when data is valid", %{conn: conn, country: country} do
      conn = put(conn, ~p"/countries/#{country}", country: @update_attrs)
      assert redirected_to(conn) == ~p"/countries/#{country}"

      conn = get(conn, ~p"/countries/#{country}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, country: country} do
      conn = put(conn, ~p"/countries/#{country}", country: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Country"
    end
  end

  describe "delete country" do
    setup [:create_country]

    test "deletes chosen country", %{conn: conn, country: country} do
      conn = delete(conn, ~p"/countries/#{country}")
      assert redirected_to(conn) == ~p"/countries"

      assert_error_sent 404, fn ->
        get(conn, ~p"/countries/#{country}")
      end
    end
  end

  defp create_country(_) do
    country = country_fixture()
    %{country: country}
  end
end
