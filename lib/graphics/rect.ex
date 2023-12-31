defmodule Graphics.Rect do
  defstruct x: 0, y: 0, width: 0, height: 0

  @type t() :: %__MODULE__{
          :x => Float.t(),
          :y => Float.t(),
          :width => Float.t(),
          :height => Float.t()
        }
end
