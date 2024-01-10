defmodule RocketsizedWeb.RenderController do
  use RocketsizedWeb, :controller

  alias Rocketsized.Rocket
  alias Rocketsized.Rocket.Render.Image
  alias RocketsizedWeb.FilterParams

  def render(conn, %{"type" => type} = params)
      when type in ["portrait", "landscape", "wallpaper"] do
    {:ok, flop} = Flop.validate(FilterParams.load_params(params), for: Rocket.Vehicle)
    render = Rocket.flop_render_find_or_create(flop, to_type(type))
    send_download(conn, {:file, Image.storage_file_path({render.image, render})})
  end

  def preview(conn, %{"type" => type} = params)
      when type in ["portrait", "landscape", "wallpaper"] do
    {:ok, flop} = Flop.validate(FilterParams.load_params(params), for: Rocket.Vehicle)

    conn
    |> put_resp_content_type("image/svg+xml")
    |> put_root_layout(false)
    |> put_layout(false)
    |> text(Rocket.flop_render_binary(flop, to_type(type)))
  end

  defp to_type("portrait"), do: :portrait
  defp to_type("landscape"), do: :landscape
  defp to_type("wallpaper"), do: :wallpaper
end
