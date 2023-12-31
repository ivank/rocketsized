defmodule Graphics.UtilsTest do
  use ExUnit.Case
  import Graphics.Interface
  import Graphics.Utils

  defp rects_square(_) do
    %{
      rects: [
        rect(1, 1, 0, 0),
        rect(2, 2, 1, 1),
        rect(3, 3, 2, 2)
      ]
    }
  end

  describe "Graphic utils" do
    setup [:rects_square]

    test "transform" do
      assert transform(rect(100, 100), set_width(50)) == rect(50, 50)
      assert transform(rect(10, 100), set_width(50)) == rect(50, 500)
      assert transform(rect(100, 10), set_width(50)) == rect(50, 5)
      assert transform(rect(23, 31), set_width(18)) == rect(18, 24.26086956521739)

      assert transform(rect(100, 100), set_height(50)) == rect(50, 50)
      assert transform(rect(10, 100), set_height(50)) == rect(5, 50)
      assert transform(rect(100, 10), set_height(50)) == rect(500, 50)
      assert transform(rect(23, 31), set_height(18)) == rect(13.35483870967742, 18)
    end

    test "max_height" do
      assert max_height([rect(100, 100), rect(50, 50)]) == 100

      assert max_height([rect(1, 1)]) == 1

      assert max_height([rect(5, 100, 10, 10), rect(1, 1), rect(1, 1, 50, 50)]) == 100
    end

    test "bounds", %{rects: rects} do
      assert left(rects) == 0
      assert right(rects) == 5
      assert top(rects) == 0
      assert bottom(rects) == 5

      assert bottom(rect(5, 10, 5, 5)) == 15
      assert right(rect(5, 10, 5, 5)) == 10

      assert bottom(rect(5, 10, 5, 5), 20) == rect(5, 10, 5, 10)
      assert right(rect(5, 10, 5, 5), 20) == rect(5, 10, 15, 5)
    end

    test "threshold" do
      assert threshold_left(rect(5, 10, 5, 5), 0) == rect(5, 10, 5, 5)
      assert threshold_left(rect(5, 10, 5, 5), 10) == rect(5, 10, 10, 5)

      assert threshold_right(rect(5, 10, 5, 5), 0) == rect(5, 10, -5, 5)
      assert threshold_right(rect(5, 10, 5, 5), 20) == rect(5, 10, 5, 5)

      assert threshold_top(rect(5, 10, 5, 5), 0) == rect(5, 10, 5, 5)
      assert threshold_top(rect(5, 10, 5, 5), 10) == rect(5, 10, 5, 10)

      assert threshold_bottom(rect(5, 10, 5, 5), 0) == rect(5, 10, 5, -10)
      assert threshold_bottom(rect(5, 10, 5, 5), 20) == rect(5, 10, 5, 5)
    end

    test "push" do
      assert push_right(rect(5, 5, 10), rect(5, 5, 0)) == rect(5, 5, 10)
      assert push_right(rect(5, 5, 5), rect(5, 5, 0), gap: 2) == rect(5, 5, 7)
      assert push_right(rect(5, 5, 5), nil, gap: 2) == rect(5, 5, 5)
      assert push_bottom(rect(5, 5, 0, 10), rect(5, 5)) == rect(5, 5, 0, 10)
      assert push_bottom(rect(5, 5, 0, 5), rect(5, 5), gap: 2) == rect(5, 5, 0, 7)
      assert push_bottom(rect(5, 5, 0, 10), nil) == rect(5, 5, 0, 10)
    end

    test "transform align", %{rects: rects} do
      assert transform(rects, align(top: 0)) == [
               rect(1, 1, 0, 0),
               rect(2, 2, 1, 0),
               rect(3, 3, 2, 0)
             ]

      assert transform(rects, align(bottom: 10)) == [
               rect(1, 1, 0, 9),
               rect(2, 2, 1, 8),
               rect(3, 3, 2, 7)
             ]

      assert transform(rects, align(left: 0)) == [
               rect(1, 1, 0, 0),
               rect(2, 2, 0, 1),
               rect(3, 3, 0, 2)
             ]

      assert transform(rects, align(right: 10)) == [
               rect(1, 1, 9, 0),
               rect(2, 2, 8, 1),
               rect(3, 3, 7, 2)
             ]
    end

    test "transform spread_horizontal", %{rects: rects} do
      assert transform(rects, spread_horizontal(9)) == [
               rect(1, 1, 1, 0),
               rect(2, 2, 3.5, 1),
               rect(3, 3, 6, 2)
             ]

      assert transform(rects, spread_horizontal(6, gap: 2)) == [
               rect(1, 1, 0.5, 0),
               rect(2, 2, 3.5, 1),
               rect(3, 3, 7.5, 2)
             ]

      assert transform(rects, spread_horizontal(9, x: 2)) == [
               rect(1, 1, 3, 0),
               rect(2, 2, 5.5, 1),
               rect(3, 3, 8, 2)
             ]
    end

    test "transform spread_vertical", %{rects: rects} do
      assert transform(rects, spread_vertical(9)) == [
               rect(1, 1, 0, 1),
               rect(2, 2, 1, 3.5),
               rect(3, 3, 2, 6)
             ]

      assert transform(rects, spread_vertical(6, gap: 2)) == [
               rect(1, 1, 0, 0.5),
               rect(2, 2, 1, 3.5),
               rect(3, 3, 2, 7.5)
             ]

      assert transform(rects, spread_vertical(18, rows: 6)) == [
               rect(1, 1, 0, 1),
               rect(2, 2, 1, 3.5),
               rect(3, 3, 2, 6)
             ]

      assert transform(rects, spread_vertical(9, y: 2)) == [
               rect(1, 1, 0, 3),
               rect(2, 2, 1, 5.5),
               rect(3, 3, 2, 8)
             ]
    end

    test "transform distribute_horizontal", %{rects: rects} do
      assert transform(rects, distribute_horizontal(12)) == [
               rect(1, 1, 0, 0),
               rect(2, 2, 4, 1),
               rect(3, 3, 9, 2)
             ]

      assert transform(rects, distribute_vertical(12)) == [
               rect(1, 1, 0, 0),
               rect(2, 2, 1, 4),
               rect(3, 3, 2, 9)
             ]
    end

    test "transform flow_horizontal", %{rects: rects} do
      assert transform(rects, flow_horizontal()) == [
               rect(1, 1, 0, 0),
               rect(2, 2, 1, 1),
               rect(3, 3, 3, 2)
             ]

      assert transform(rects, flow_horizontal(gap: 2)) == [
               rect(1, 1, 0, 0),
               rect(2, 2, 3, 1),
               rect(3, 3, 7, 2)
             ]
    end

    test "transform flow_vertical", %{rects: rects} do
      assert transform(rects, flow_vertical()) == [
               rect(1, 1, 0, 0),
               rect(2, 2, 1, 1),
               rect(3, 3, 2, 3)
             ]

      assert transform(rects, flow_vertical(gap: 2)) == [
               rect(1, 1, 0, 0),
               rect(2, 2, 1, 3),
               rect(3, 3, 2, 7)
             ]
    end

    test "transform real test" do
      rects = [
        rect(1000, 424),
        rect(1000, 217),
        rect(1000, 186),
        rect(1000, 168),
        rect(1000, 152),
        rect(1000, 126),
        rect(1000, 105),
        rect(1000, 87),
        rect(1000, 72)
      ]

      expects = [
        rect(1000, 424, 0, 0),
        rect(1000, 217, 0, 731.875),
        rect(1000, 186, 0, 1256.75),
        rect(1000, 168, 0, 1750.625),
        rect(1000, 152, 0, 2226.5),
        rect(1000, 126, 0, 2686.375),
        rect(1000, 105, 0, 3120.25),
        rect(1000, 87, 0, 3533.125),
        rect(1000, 72, 0, 3928.0)
      ]

      assert transform(rects, distribute_vertical(4000)) == expects
    end

    test "center" do
      assert center_x(rect(10, 10)) == 5
      assert center_x(rect(6, 6, 10, 20)) == 13

      assert center_x(rect(10, 10), 10) == rect(10, 10, 5, 0)
      assert center_x(rect(6, 6, 10, 20), 20) == rect(6, 6, 17, 20)

      assert center_y(rect(10, 10)) == 5
      assert center_y(rect(6, 6, 10, 20)) == 23

      assert center_y(rect(10, 10), 10) == rect(10, 10, 0, 5)
      assert center_y(rect(6, 6, 10, 20), 20) == rect(6, 6, 10, 17)
    end
  end
end
