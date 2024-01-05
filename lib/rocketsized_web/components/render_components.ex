defmodule RocketsizedWeb.RenderComponent do
  alias Rocketsized.Rocket.Vehicle
  use Phoenix.Component

  alias Rocketsized.Rocket.Vehicle.Image
  alias Rocketsized.Creator.Country.Flag
  import RectLayout

  def poster(assigns) do
    ~H"""
    <svg
      style="stroke-linecap:round;stroke-linejoin:round;"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      xmlns="http://www.w3.org/2000/svg"
      xml:space="preserve"
      version="1.1"
      width={width(@canvas)}
      height={height(@canvas)}
      viewBox={"0 0 #{width(@canvas)} #{height(@canvas)}"}
    >
      <style>
        @font-face {
          font-family: 'Space Grotesk';
          font-style: normal;
          font-weight: 400;
          font-display: swap;
          src: url('<%= image_data(:woff2, Application.app_dir(:rocketsized, "priv/static/fonts/SpaceGroteskRegular.woff2")) %>') format('woff2');
          unicode-range: U+0100-02AF, U+0304, U+0308, U+0329, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
        }
        svg {
          font-family: "Space Grotesk", sans-serif;
        }
        .h1 {
          font-size: 50px;
          fill: #14213D;
          text-anchor:end;
          dominant-baseline:middle;
          text-decoration:underline;
        }
        .h1.subtitle {
          font-size: 20px;
          text-decoration:none;
        }
        .h2 {
          text-anchor:middle;
          font-size: <%= @infobox_height * 0.21 %>px;
          fill: #14213D;
        }
        .h3 {
          text-anchor:middle;
          fill: #8f98ae;
          font-size: <%= @infobox_height * 0.14 %>px;
        }
        .credit {
          fill: #8f98ae;
          font-size: 8px;
          text-anchor: end;
        }
        .border {
          stroke: #E5E5E5;
          stroke-width: 2px;
          fill: none;
        }
      </style>
      <defs>
        <linearGradient id="bg-style">
          <stop style="stop-color: #ffffff;" offset="0" />
          <stop style="stop-color: #efefef;" offset="0.15" />
          <stop style="stop-color: #f2f2f2;" offset="0.4" />
          <stop style="stop-color: #ffffff;" offset="1" />
        </linearGradient>
        <linearGradient
          :for={{row, index} <- Enum.with_index(@rows)}
          gradientUnits="userSpaceOnUse"
          id={"bg-#{index}"}
          x1={x(row) + width(row) / 2}
          y1={y(row) + height(row)}
          x2={x(row) + width(row) / 2}
          y2={y(row)}
          xlink:href="#bg-style"
        />
      </defs>
      <g>
        <rect
          id="border"
          x={x(@border)}
          y={y(@border)}
          width={width(@border)}
          height={height(@border)}
          class="border"
          rx="10"
        />
        <g :for={{row, index} <- Enum.with_index(@rows)} id={"row-#{index}"}>
          <rect
            width={width(@border) - 2}
            height={height(row) + 50}
            x={x(@border) + 1}
            y={y(row)}
            stroke="none"
            style={"fill: url(#bg-#{index});"}
          />
          <g
            :for={%{children: [item, flag, text]} <- group_children(row)}
            id={"rocket-#{sprite_content(item).id}"}
          >
            <image
              width={width(item)}
              height={height(item)}
              x={x(item)}
              y={y(item)}
              xlink:href={
                image_data(
                  sprite_content(item).image_meta.type,
                  Image.storage_file_path({sprite_content(item).image, sprite_content(item)})
                )
              }
            />
            <image
              width={width(flag)}
              height={height(flag)}
              x={x(flag)}
              y={y(flag)}
              xlink:href={
                image_data(
                  :svg,
                  Flag.storage_file_path({sprite_content(flag).flag, sprite_content(flag)})
                )
              }
            />

            <g transform={"translate(#{x(text)},#{y(text)})"}>
              <rect width={width(text)} height={height(text)} fill="none" />
              <text x={width(text) / 2} y={@infobox_height * 0.12} class="h2">
                <%= sprite_content(text) %>
              </text>
              <text
                :for={
                  {subtitle, index} <-
                    [sprite_content(item).alternative_name, sprite_content(item).native_name]
                    |> Enum.filter(& &1)
                    |> Enum.with_index()
                }
                x={width(text) / 2}
                y={@infobox_height * 0.32 + index * @infobox_height * 0.18}
                class="h3"
              >
                <%= subtitle %>
              </text>
            </g>
          </g>
        </g>
        <g transform={"translate(#{x(@title)}, #{y(@title)})"} id="title">
          <rect width={width(@title)} height={height(@title)} fill="none" id="spacer" />
          <text x={width(@title)} y={height(@title) / 2} class="h1" id="h1">
            LAUNCH VEHICLES <%= sprite_content(@title) %>
          </text>
          <text x={width(@title)} y={height(@title)} class="h1 subtitle" id="h1-sub">
            ROCKETSIZED by Ivan Kerin
          </text>
        </g>
        <text
          :if={sprite_content(@credit) != ""}
          x={x(@credit)}
          y={y(@credit)}
          width={x(@credit)}
          height={height(@credit)}
          class="credit"
        >
          Credit: <%= sprite_content(@credit) %>
        </text>
      </g>
    </svg>
    """
  end

  def preview(assigns) do
    ~H"""
    <svg
      style="stroke-linecap:round;stroke-linejoin:round;"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      xmlns="http://www.w3.org/2000/svg"
      xml:space="preserve"
      version="1.1"
      width={width(@canvas)}
      height={height(@canvas)}
      viewBox={"0 0 #{width(@canvas)} #{height(@canvas)}"}
    >
      <style>
        @font-face {
          font-family: 'Space Grotesk';
          font-style: normal;
          font-weight: 400;
          font-display: swap;
          src: url('<%= image_data(:woff2, Application.app_dir(:rocketsized, "priv/static/fonts/SpaceGroteskRegular.woff2")) %>') format('woff2');
          unicode-range: U+0100-02AF, U+0304, U+0308, U+0329, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
        }
        svg {
          font-family: "Space Grotesk", sans-serif;
        }
        .h1 {
          font-size: 50px;
          fill: #14213D;
          text-anchor:end;
          dominant-baseline:middle;
          text-decoration:underline;
        }
        .h1.subtitle {
          font-size: 20px;
          text-decoration:none;
        }
        .border {
          stroke: #E5E5E5;
          stroke-width: 2px;
          fill: none;
        }
      </style>
      <defs>
        <linearGradient id="bg-style">
          <stop style="stop-color: #ffffff;" offset="0" />
          <stop style="stop-color: #efefef;" offset="0.15" />
          <stop style="stop-color: #f2f2f2;" offset="0.4" />
          <stop style="stop-color: #ffffff;" offset="1" />
        </linearGradient>
        <linearGradient
          :for={{row, index} <- Enum.with_index(@rows)}
          gradientUnits="userSpaceOnUse"
          id={"bg-#{index}"}
          x1={x(row) + width(row) / 2}
          y1={y(row) + height(row)}
          x2={x(row) + width(row) / 2}
          y2={y(row)}
          xlink:href="#bg-style"
        />
      </defs>
      <g>
        <rect
          id="border"
          x={x(@border)}
          y={y(@border)}
          width={width(@border)}
          height={height(@border)}
          class="border"
          rx="10"
        />
        <g :for={{row, index} <- Enum.with_index(@rows)} id={"row-#{index}"}>
          <rect
            width={width(@border) - 2}
            height={height(row) + 50}
            x={x(@border) + 1}
            y={y(row)}
            stroke="none"
            style={"fill: url(#bg-#{index});"}
          />
          <g
            :for={%{children: [item, flag, text]} <- group_children(row)}
            id={"rocket-#{sprite_content(item).id}"}
          >
            <rect
              width={width(item)}
              height={height(item)}
              x={x(item)}
              y={y(item)}
              rx="10"
              fill="#14213D50"
            />
            <rect width={width(flag)} height={height(flag)} x={x(flag)} y={y(flag)} fill="#14213D30" />
            <rect x={x(text)} y={y(text)} width={width(text)} height={height(text)} fill="#14213D10" />
          </g>
        </g>
        <g transform={"translate(#{x(@title)}, #{y(@title)})"} id="title">
          <rect width={width(@title)} height={height(@title)} fill="none" id="spacer" />
          <text x={width(@title)} y={height(@title) / 2} class="h1" id="h1">
            LAUNCH VEHICLES <%= sprite_content(@title) %>
          </text>
          <text x={width(@title)} y={height(@title)} class="h1 subtitle" id="h1-sub">
            ROCKETSIZED by Ivan Kerin
          </text>
        </g>
      </g>
    </svg>
    """
  end

  defp image_data(:png, path), do: "data:image/png;base64,#{Base.encode64(File.read!(path))}"
  defp image_data(:jpg, path), do: "data:image/jpg;base64,#{Base.encode64(File.read!(path))}"
  defp image_data(:svg, path), do: "data:image/svg+xml;base64,#{Base.encode64(File.read!(path))}"
  defp image_data(:ttf, path), do: "data:font/ttf;base64,#{Base.encode64(File.read!(path))}"
  defp image_data(:woff2, path), do: "data:font/woff2;base64,#{Base.encode64(File.read!(path))}"

  @type positions_option :: [
          {:title, String.t()}
          | {:credit, String.t()}
          | {:width, number()}
          | {:height, number()}
          | {:padding, number()}
          | {:gap, number()}
        ]
  @spec positions(rockets :: list(Vehicle.t()), options :: positions_option()) :: [
          infobox_height: number(),
          canvas: number(),
          border: number(),
          title: String.t() | nil,
          credit: String.t() | nil,
          rows: list(RectLayout.Group.t())
        ]
  def positions(rockets, options) do
    options =
      Keyword.validate!(options,
        title: nil,
        credit: nil,
        width: 100,
        height: 100,
        padding: 40,
        gap: 40
      )

    width = options[:width] - 2 * options[:padding]
    height = options[:height] - 2 * options[:padding]

    pixels_per_rocket = width * height / length(rockets)
    ratios = rockets |> Enum.map(&(&1.image_meta.width / &1.image_meta.height))
    average_ratio = Enum.sum(ratios) / length(ratios)
    rocket_width = round(average_ratio * (pixels_per_rocket / average_ratio) ** 0.5 * 1.3)

    infobox_height = rocket_width * 0.4
    cols = Integer.floor_div(width, rocket_width)

    row_heights =
      rockets
      |> Enum.chunk_every(cols)
      |> Enum.map(fn col -> col |> Enum.map(& &1.height) |> Enum.max() end)

    row_count = length(row_heights)

    row_height_zoom =
      (height - (row_count - 1) * options[:gap] - row_count * infobox_height) /
        Enum.sum(row_heights)

    [
      infobox_height: infobox_height,
      canvas: rect(options[:width], options[:height]),
      border: rect(options[:width], options[:height]) |> extrude(-options[:padding] / 2),
      title:
        sprite(
          rect(900, 70) |> right(options[:width] - 70) |> y(70),
          String.upcase(options[:title])
        ),
      credit:
        sprite(
          rect(
            options[:width],
            8,
            options[:width] - options[:padding],
            options[:height] - options[:padding]
          ),
          options[:credit]
        ),
      rows:
        rockets
        |> Enum.map(&sprite(rect(&1.image_meta.width, &1.image_meta.height), &1))
        |> Enum.chunk_every(cols)
        |> Enum.map(fn items ->
          group(
            items
            |> Enum.map(&constrain_height(&1, sprite_content(&1).height * row_height_zoom))
            |> spread_horizontal(width, x: options[:padding], cols: cols, gap: options[:gap])
            |> align_bottom()
            |> Enum.map(fn image ->
              flag =
                sprite(rect(24, 15), sprite_content(image).country)
                |> constrain_height(infobox_height * 0.25)
                |> y(bottom(image) + infobox_height * 0.08)
                |> center_x(center_x(image))

              text =
                sprite(
                  rect(Integer.floor_div(width, cols) - options[:gap], infobox_height * 0.5),
                  sprite_content(image).name
                )
                |> y(bottom(flag) + infobox_height * 0.08)
                |> center_x(center_x(image))

              group([image, flag, text])
            end)
          )
        end)
        |> flow_vertical(gap: options[:gap], y: options[:padding])
    ]
  end
end
