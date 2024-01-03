defmodule RocketsizedWeb.PosterHTML do
  use RocketsizedWeb, :html

  alias Rocketsized.Rocket.Vehicle.Image
  alias Rocketsized.Creator.Country.Flag
  import RectLayout

  def index(assigns) do
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
          :for={{group, index} <- Enum.with_index(@rockets)}
          gradientUnits="userSpaceOnUse"
          id={"bg-#{index}"}
          x1={x(group) + width(group) / 2}
          y1={y(group) + height(group)}
          x2={x(group) + width(group) / 2}
          y2={y(group)}
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
        <g :for={{group, index} <- Enum.with_index(@rockets)} id={"row-#{index}"}>
          <rect
            width={width(@border) - 2}
            height={height(group) + 50}
            x={x(@border) + 1}
            y={y(group)}
            stroke="none"
            style={"fill: url(#bg-#{index});"}
          />
          <g
            :for={%{children: [item, flag, text]} <- group_children(group)}
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
      </g>
    </svg>
    """
  end

  defp image_data(:png, path), do: "data:image/png;base64,#{Base.encode64(File.read!(path))}"
  defp image_data(:jpg, path), do: "data:image/jpg;base64,#{Base.encode64(File.read!(path))}"
  defp image_data(:svg, path), do: "data:image/svg+xml;base64,#{Base.encode64(File.read!(path))}"
  defp image_data(:ttf, path), do: "data:font/ttf;base64,#{Base.encode64(File.read!(path))}"
  defp image_data(:woff2, path), do: "data:font/woff2;base64,#{Base.encode64(File.read!(path))}"
end
