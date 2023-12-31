defmodule Graphics.Sprite do
  alias Graphics.Rect
  defstruct rect: %Rect{}, value: nil

  @type t() :: %__MODULE__{:rect => Rect.t(), :value => any()}
end
