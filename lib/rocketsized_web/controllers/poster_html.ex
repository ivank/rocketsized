defmodule RocketsizedWeb.PosterHTML do
  use RocketsizedWeb, :html

  def index(assigns) do
    ~H"""
    <RocketsizedWeb.RenderComponent.poster
      font_size={@font_size}
      canvas={@canvas}
      border={@border}
      title={@title}
      credit={@credit}
      rows={@rows}
    />
    """
  end
end
