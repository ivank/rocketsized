defmodule RocketsizedWeb.PosterController do
  use RocketsizedWeb, :controller

  alias Rocketsized.Rocket.Vehicle
  alias Rocketsized.Rocket

  plug :put_layout, false

  def index(conn, %{"type" => type} = params) when type in ["portrait", "landscape"] do
    opts = [for: Rocket.Vehicle, pagination: false, default_limit: 500]
    {:ok, flop} = Flop.validate(params, opts)
    {rockets, meta} = Rocket.list_vehicles_with_flop(flop)

    title = Rocket.vehicle_filters_title_for_flop(meta.flop)

    credit = Vehicle.to_title(rockets)

    {width, height} =
      case type do
        "portrait" -> {2828, 4000}
        "landscape" -> {4000, 2828}
      end

    conn
    |> put_resp_content_type("image/svg+xml")
    # |> put_resp_header(
    #   "content-disposition",
    #   ~s[attachment; filename="rockets-#{Slug.slugify(title)}-#{type}.svg"]
    # )
    |> put_root_layout(false)
    |> render(
      :index,
      RocketsizedWeb.RenderComponent.positions(rockets,
        title: title,
        credit: credit,
        width: width,
        height: height
      )
    )
  end
end
