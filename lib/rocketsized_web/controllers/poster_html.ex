defmodule RocketsizedWeb.PosterHTML do
  use RocketsizedWeb, :html

  def index(assigns) do
    ~H"""
    <RocketsizedWeb.RenderComponent.poster
      infobox_height={@infobox_height}
      canvas={@canvas}
      border={@border}
      title={@title}
      credit={@credit}
      rows={@rows}
    />
    """
  end
end
