defmodule RocketsizedWeb.FamilyControllerTest do
  use RocketsizedWeb.ConnCase

  import Rocketsized.RocketFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "index" do
    test "lists all families", %{conn: conn} do
      conn = get(conn, ~p"/families")
      assert html_response(conn, 200) =~ "Listing Families"
    end
  end

  describe "new family" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/families/new")
      assert html_response(conn, 200) =~ "New Family"
    end
  end

  describe "create family" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/families", family: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/families/#{id}"

      conn = get(conn, ~p"/families/#{id}")
      assert html_response(conn, 200) =~ "Family #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/families", family: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Family"
    end
  end

  describe "edit family" do
    setup [:create_family]

    test "renders form for editing chosen family", %{conn: conn, family: family} do
      conn = get(conn, ~p"/families/#{family}/edit")
      assert html_response(conn, 200) =~ "Edit Family"
    end
  end

  describe "update family" do
    setup [:create_family]

    test "redirects when data is valid", %{conn: conn, family: family} do
      conn = put(conn, ~p"/families/#{family}", family: @update_attrs)
      assert redirected_to(conn) == ~p"/families/#{family}"

      conn = get(conn, ~p"/families/#{family}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, family: family} do
      conn = put(conn, ~p"/families/#{family}", family: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Family"
    end
  end

  describe "delete family" do
    setup [:create_family]

    test "deletes chosen family", %{conn: conn, family: family} do
      conn = delete(conn, ~p"/families/#{family}")
      assert redirected_to(conn) == ~p"/families"

      assert_error_sent 404, fn ->
        get(conn, ~p"/families/#{family}")
      end
    end
  end

  defp create_family(_) do
    family = family_fixture()
    %{family: family}
  end
end
