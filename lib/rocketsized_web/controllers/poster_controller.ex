defmodule RocketsizedWeb.PosterController do
  use RocketsizedWeb, :controller

  alias Rocketsized.Rocket

  plug :put_layout, false

  def index(conn, %{"type" => type} = params)
      when type in ["poster_portrait", "poster_landscape", "wallpaper"] do
    {:ok, flop} = Flop.validate(params, for: Rocket.Vehicle)
    render = Rocket.flop_render_find_or_create(flop, to_type(type))

    send_download(
      conn,
      {:file, Rocketsized.Rocket.Render.Image.storage_file_path({render.image, render})}
    )
  end

  defp to_type("poster_portrait"), do: :poster_portrait
  defp to_type("poster_landscape"), do: :poster_landscape
  defp to_type("wallpaper"), do: :wallpaper
end
