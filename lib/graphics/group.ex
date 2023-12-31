defmodule Graphics.Group do
  alias Graphics.Rect
  defstruct rect: %Rect{}, children: []

  @type t() :: %__MODULE__{:rect => Rect.t(), :children => list()}
end
