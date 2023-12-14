defmodule RocketsizedWeb.LaunchControllerTest do
  use RocketsizedWeb.ConnCase

  import Rocketsized.RocketFixtures

  @create_attrs %{status: :success, launched_at: ~U[2023-12-06 06:40:00Z], details: "some details"}
  @update_attrs %{status: :failure, launched_at: ~U[2023-12-07 06:40:00Z], details: "some updated details"}
  @invalid_attrs %{status: nil, launched_at: nil, details: nil}

  describe "index" do
    test "lists all launches", %{conn: conn} do
      conn = get(conn, ~p"/launches")
      assert html_response(conn, 200) =~ "Listing Launches"
    end
  end

  describe "new launch" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/launches/new")
      assert html_response(conn, 200) =~ "New Launch"
    end
  end

  describe "create launch" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/launches", launch: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/launches/#{id}"

      conn = get(conn, ~p"/launches/#{id}")
      assert html_response(conn, 200) =~ "Launch #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/launches", launch: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Launch"
    end
  end

  describe "edit launch" do
    setup [:create_launch]

    test "renders form for editing chosen launch", %{conn: conn, launch: launch} do
      conn = get(conn, ~p"/launches/#{launch}/edit")
      assert html_response(conn, 200) =~ "Edit Launch"
    end
  end

  describe "update launch" do
    setup [:create_launch]

    test "redirects when data is valid", %{conn: conn, launch: launch} do
      conn = put(conn, ~p"/launches/#{launch}", launch: @update_attrs)
      assert redirected_to(conn) == ~p"/launches/#{launch}"

      conn = get(conn, ~p"/launches/#{launch}")
      assert html_response(conn, 200) =~ "some updated details"
    end

    test "renders errors when data is invalid", %{conn: conn, launch: launch} do
      conn = put(conn, ~p"/launches/#{launch}", launch: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Launch"
    end
  end

  describe "delete launch" do
    setup [:create_launch]

    test "deletes chosen launch", %{conn: conn, launch: launch} do
      conn = delete(conn, ~p"/launches/#{launch}")
      assert redirected_to(conn) == ~p"/launches"

      assert_error_sent 404, fn ->
        get(conn, ~p"/launches/#{launch}")
      end
    end
  end

  defp create_launch(_) do
    launch = launch_fixture()
    %{launch: launch}
  end
end
