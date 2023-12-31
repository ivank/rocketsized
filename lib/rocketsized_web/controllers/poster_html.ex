defmodule RocketsizedWeb.PosterHTML do
  use RocketsizedWeb, :html

  alias Rocketsized.Rocket.Vehicle.Image
  alias Rocketsized.Creator.Country.Flag

  def index(assigns) do
    ~H"""
    <svg
      style="stroke-linecap:round;stroke-linejoin:round;"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      xmlns="http://www.w3.org/2000/svg"
      xml:space="preserve"
      version="1.1"
      width={@canvas.width}
      height={@canvas.height}
      viewBox={"0 0 #{@canvas.width} #{@canvas.height}"}
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
          font-size: 120px;
          fill: #333333;
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
          font-size: 12px;
          fill: #333333;
        }
        .h3 {
          text-anchor:middle;
          fill: #666666;
          font-size: 8px;
        }
        .flag-border {
          fill: #F6F6F6;
        }
        .border {
          stroke: #D0D0D0;
          stroke-width: 2px;
          fill: none;
        }
      </style>
      <rect x={@border.x} y={@border.y} width={@border.width} height={@border.height} class="border" />
      <g transform={"translate(#{@text.x}, #{@text.y})"}>
        <rect width={@text.width} height={@text.height} fill="none" />
        <text x={@text.width} y={@text.height / 2} class="h1">ROCKETSIZED</text>
        <text x={@text.width} y={@text.height} class="h1 subtitle">by Ivan Kerin</text>
      </g>
      <g :for={group <- @rockets}>
        <g :for={%{children: [item, flag, text]} <- group.children}>
          <image
            width={item.rect.width}
            height={item.rect.height}
            x={item.rect.x}
            y={item.rect.y}
            xlink:href={
              image_data(
                item.value.image_meta.type,
                Image.storage_file_path({item.value.image, item.value})
              )
            }
          />
          <rect
            width={flag.rect.width + 1}
            height={flag.rect.height + 1}
            x={flag.rect.x - 0.5}
            y={flag.rect.y - 0.5}
            class="flag-border"
          />
          <image
            width={flag.rect.width}
            height={flag.rect.height}
            x={flag.rect.x}
            y={flag.rect.y}
            xlink:href={image_data(:svg, Flag.storage_file_path({flag.value.flag, flag.value}))}
          />

          <g transform={"translate(#{text.rect.x},#{text.rect.y})"}>
            <rect width={text.rect.width} height={text.rect.height} fill="none" />
            <text x={text.rect.width / 2} y="7" class="h2">
              <%= item.value.name %>
            </text>
            <text
              :for={
                {subtitle, index} <-
                  [item.value.alternative_name, item.value.native_name]
                  |> Enum.filter(& &1)
                  |> Enum.with_index()
              }
              x={text.rect.width / 2}
              y={20 + index * 10}
              class="h3"
            >
              <%= subtitle %>
            </text>
          </g>
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
