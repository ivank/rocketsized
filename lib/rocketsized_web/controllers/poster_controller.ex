defmodule RocketsizedWeb.PosterController do
  use RocketsizedWeb, :controller

  import RectLayout
  alias Rocketsized.Rocket

  plug :put_layout, false

  def index(conn, %{"type" => type} = params) when type in ["portrait", "landscape"] do
    opts = [for: Rocket.Vehicle, pagination: false, default_limit: 500]
    {:ok, flop} = Flop.validate(params, opts)
    {rockets, meta} = Rocket.list_vehicles_with_flop(flop)

    title = Rocket.vehicle_filters_title_for_flop(meta.flop)

    credit =
      rockets
      |> Enum.map(& &1.image_meta.attribution)
      |> Enum.filter(& &1)
      |> Enum.map(&Floki.text(Floki.parse_document!(&1)))
      |> Enum.uniq()
      |> Enum.join(", ")

    dimensions =
      case type do
        "portrait" -> {2828, 4000}
        "landscape" -> {4000, 2828}
      end

    conn
    |> put_resp_content_type("image/svg+xml")
    |> put_resp_header(
      "content-disposition",
      ~s[attachment; filename="rockets-#{Slug.slugify(title)}-#{type}.svg"]
    )
    |> put_root_layout(false)
    |> render(:index, rockets_position(rockets, title, credit, dimensions))
  end

  defp rockets_max_height(items), do: items |> Enum.map(& &1.height) |> Enum.max()

  defp rockets_position(rockets, title, credit, {to_width, to_height}) do
    padding = 40
    gap = 40
    width = to_width - 2 * padding
    height = to_height - 2 * padding

    pixels_per_rocket = width * height / length(rockets)
    ratios = rockets |> Enum.map(&(&1.image_meta.width / &1.image_meta.height))
    average_ratio = Enum.sum(ratios) / length(ratios)
    rocket_width = round(average_ratio * (pixels_per_rocket / average_ratio) ** 0.5 * 1.3)

    infobox_height = rocket_width * 0.4
    cols = Integer.floor_div(width, rocket_width)

    row_heights = rockets |> Enum.chunk_every(cols) |> Enum.map(&rockets_max_height/1)
    row_count = length(row_heights)

    row_height_zoom =
      (height - (row_count - 1) * gap - row_count * infobox_height) / Enum.sum(row_heights)

    [
      infobox_height: infobox_height,
      canvas: rect(to_width, to_height),
      border: rect(to_width, to_height) |> extrude(-padding / 2),
      title: sprite(rect(900, 70) |> right(to_width - 70) |> y(70), String.upcase(title)),
      credit: sprite(rect(to_width, 8, to_width - padding, to_height - padding), credit),
      rockets:
        rockets
        |> Enum.map(&sprite(rect(&1.image_meta.width, &1.image_meta.height), &1))
        |> Enum.chunk_every(cols)
        |> Enum.map(fn items ->
          group(
            items
            |> Enum.map(&constrain_height(&1, sprite_content(&1).height * row_height_zoom))
            |> spread_horizontal(width, x: padding, cols: cols, gap: gap)
            |> align_bottom()
            |> Enum.map(fn image ->
              flag =
                sprite(rect(24, 15), sprite_content(image).country)
                |> constrain_height(infobox_height * 0.25)
                |> y(bottom(image) + infobox_height * 0.08)
                |> center_x(center_x(image))

              text =
                sprite(
                  rect(Integer.floor_div(width, cols) - gap, infobox_height * 0.5),
                  sprite_content(image).name
                )
                |> y(bottom(flag) + infobox_height * 0.08)
                |> center_x(center_x(image))

              group([image, flag, text])
            end)
          )
        end)
        |> flow_vertical(gap: gap, y: padding)
    ]
  end
end
