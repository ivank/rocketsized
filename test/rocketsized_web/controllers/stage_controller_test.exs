defmodule RocketsizedWeb.StageControllerTest do
  use RocketsizedWeb.ConnCase

  import Rocketsized.RocketFixtures

  @create_attrs %{propellant: ["option1", "option2"]}
  @update_attrs %{propellant: ["option1"]}
  @invalid_attrs %{propellant: nil}

  describe "index" do
    test "lists all stages", %{conn: conn} do
      conn = get(conn, ~p"/stages")
      assert html_response(conn, 200) =~ "Listing Stages"
    end
  end

  describe "new stage" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/stages/new")
      assert html_response(conn, 200) =~ "New Stage"
    end
  end

  describe "create stage" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/stages", stage: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/stages/#{id}"

      conn = get(conn, ~p"/stages/#{id}")
      assert html_response(conn, 200) =~ "Stage #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/stages", stage: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Stage"
    end
  end

  describe "edit stage" do
    setup [:create_stage]

    test "renders form for editing chosen stage", %{conn: conn, stage: stage} do
      conn = get(conn, ~p"/stages/#{stage}/edit")
      assert html_response(conn, 200) =~ "Edit Stage"
    end
  end

  describe "update stage" do
    setup [:create_stage]

    test "redirects when data is valid", %{conn: conn, stage: stage} do
      conn = put(conn, ~p"/stages/#{stage}", stage: @update_attrs)
      assert redirected_to(conn) == ~p"/stages/#{stage}"

      conn = get(conn, ~p"/stages/#{stage}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, stage: stage} do
      conn = put(conn, ~p"/stages/#{stage}", stage: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Stage"
    end
  end

  describe "delete stage" do
    setup [:create_stage]

    test "deletes chosen stage", %{conn: conn, stage: stage} do
      conn = delete(conn, ~p"/stages/#{stage}")
      assert redirected_to(conn) == ~p"/stages"

      assert_error_sent 404, fn ->
        get(conn, ~p"/stages/#{stage}")
      end
    end
  end

  defp create_stage(_) do
    stage = stage_fixture()
    %{stage: stage}
  end
end
