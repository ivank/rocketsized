defmodule RocketsizedWeb.PosterController do
  use RocketsizedWeb, :controller

  import Graphics.Interface
  import Graphics.Utils

  alias Rocketsized.Rocket

  plug :put_layout, false

  def index(conn, _params) do
    rockets = Rocket.list_vehicles_poster()

    conn
    |> put_resp_content_type("image/svg+xml")
    |> put_root_layout(false)
    |> render(:index, rockets_position(rockets, 2828, 4000))
  end

  defp rockets_max_height(items), do: items |> Enum.map(& &1.height) |> Enum.max()

  defp rockets_position(rockets, to_width, to_height) do
    padding = 40
    gap = 40
    width = to_width - 2 * padding
    height = to_height - 2 * padding

    pixels_per_rocket = width * height / length(rockets)
    ratios = rockets |> Enum.map(&(&1.image_meta.width / &1.image_meta.height))
    average_ratio = Enum.sum(ratios) / length(ratios)
    rocket_width = round(average_ratio * (pixels_per_rocket / average_ratio) ** 0.5 * 1.3)

    infobox_height = 55
    cols = Integer.floor_div(width, rocket_width)

    row_heights = rockets |> Enum.chunk_every(cols) |> Enum.map(&rockets_max_height/1)
    row_count = length(row_heights)

    row_height_zoom =
      (height - (row_count - 1) * gap - row_count * infobox_height) / Enum.sum(row_heights)

    [
      canvas: rect(to_width, to_height),
      border: rect(to_width, to_height) |> extrude(-padding / 2),
      text: rect(900, 120) |> right(to_width - 100) |> y(100),
      rockets:
        rockets
        |> Enum.map(&sprite(rect(&1.image_meta.width, &1.image_meta.height), &1))
        |> Enum.chunk_every(cols)
        |> Enum.map(fn items ->
          group(
            items
            |> Enum.map(&transform(&1, set_height(&1.value.height * row_height_zoom)))
            |> transform(spread_horizontal(width, x: padding, cols: cols, gap: gap))
            |> transform(align(bottom: true))
            |> Enum.map(fn image ->
              flag =
                sprite(rect(24, 15), image.value.country)
                |> y(bottom(image) + 5)
                |> center_x(center_x(image))

              text =
                sprite(rect(Integer.floor_div(width, cols) - gap, 30), image.value.name)
                |> y(bottom(flag) + 5)
                |> center_x(center_x(image))

              group([image, flag, text])
            end)
          )
        end)
        |> transform(flow_vertical(gap: gap, y: padding))
    ]
  end
end
