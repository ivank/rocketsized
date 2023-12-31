defmodule Graphics.Utils do
  import Graphics.Interface

  @type set_width() :: {:set_width, Float.t()}
  @type set_height() :: {:set_height, Float.t()}
  @type align() :: {:align, keyword()}
  @type spread_horizontal() :: {:spread_horizontal, Float.t(), keyword()}
  @type spread_vertical() :: {:spread_vertical, Float.t(), keyword()}
  @type distribute_horizontal() :: {:distribute_horizontal, Float.t()}
  @type distribute_vertical() :: {:distribute_vertical, Float.t()}
  @type flow_horizontal() :: {:flow_horizontal, keyword()}
  @type flow_vertical() :: {:flow_vertical, keyword()}

  @type transformation() ::
          set_height()
          | set_width()
          | align()
          | spread_horizontal()
          | spread_vertical()
          | distribute_horizontal()
          | distribute_vertical()
          | flow_horizontal()
          | flow_vertical()

  @spec set_height(Float.t()) :: set_height()
  def set_height(param), do: {:set_height, param}

  @spec set_width(Float.t()) :: set_width()
  def set_width(param), do: {:set_width, param}

  @spec align(keyword()) :: align()
  def align(opts \\ []), do: {:align, opts}

  @spec spread_horizontal(Float.t(), keyword()) :: spread_horizontal()
  def spread_horizontal(param, opts \\ []), do: {:spread_horizontal, param, opts}

  @spec spread_vertical(Float.t(), keyword()) :: spread_vertical()
  def spread_vertical(param, opts \\ []), do: {:spread_vertical, param, opts}

  @spec distribute_horizontal(Float.t()) :: distribute_horizontal()
  def distribute_horizontal(param), do: {:distribute_horizontal, param}

  @spec distribute_vertical(Float.t()) :: distribute_vertical()
  def distribute_vertical(param), do: {:distribute_vertical, param}

  @spec flow_horizontal(keyword()) :: flow_horizontal()
  def flow_horizontal(opts \\ []), do: {:flow_horizontal, opts}

  @spec flow_vertical(keyword()) :: flow_vertical()
  def flow_vertical(opts \\ []), do: {:flow_vertical, opts}

  # Item
  # ---------------------------

  @spec threshold_left(Interface.t(), Float.t()) :: Interface.t()
  def threshold_left(item, value), do: if(x(item) < value, do: x(item, value), else: item)

  @spec threshold_right(Interface.t(), Float.t()) :: Interface.t()
  def threshold_right(item, value),
    do: if(right(item) > value, do: right(item, value), else: item)

  @spec threshold_top(Interface.t(), Float.t()) :: Interface.t()
  def threshold_top(item, value), do: if(y(item) < value, do: y(item, value), else: item)

  @spec threshold_bottom(Interface.t(), Float.t()) :: Interface.t()
  def threshold_bottom(item, value),
    do: if(bottom(item) > value, do: bottom(item, value), else: item)

  @spec push_right(Interface.t(), Interface.t() | nil, keyword()) :: Interface.t()
  def push_right(_item, _from, opts \\ [])
  def push_right(item, nil, _opts), do: item

  def push_right(item, from, opts) do
    opts = Keyword.validate!(opts, gap: 0)
    border = right(from) + opts[:gap]
    if x(item) < border, do: x(item, border), else: item
  end

  @spec push_bottom(Interface.t(), Interface.t() | nil, keyword()) :: Interface.t()
  def push_bottom(_item, _from, opts \\ [])
  def push_bottom(item, nil, _opts), do: item

  def push_bottom(item, from, opts) do
    opts = Keyword.validate!(opts, gap: 0)
    border = bottom(from) + opts[:gap]
    if y(item) < border, do: y(item, border), else: item
  end

  @spec extrude(Interface.t(), Float.t()) :: Interface.t()
  def extrude(item, value) do
    item
    |> x(x(item) - value)
    |> y(y(item) - value)
    |> width(width(item) + value * 2)
    |> height(height(item) + value * 2)
  end

  # List
  # ---------------------------

  @spec max_height(list(Interface.t())) :: Float.t()
  def max_height(rects), do: rects |> Enum.map(&height/1) |> Enum.max()

  @spec max_width(list(Interface.t())) :: Float.t()
  def max_width(rects), do: rects |> Enum.map(&width/1) |> Enum.max()

  @spec left(list(Interface.t())) :: Float.t()
  def left(rects), do: rects |> Enum.map(&x/1) |> Enum.min()

  @spec top(list(Interface.t())) :: Float.t()
  def top(rects), do: rects |> Enum.map(&y/1) |> Enum.min()

  @spec right(Interface.t() | list(Interface.t())) :: Float.t()
  def right(items) when is_list(items), do: items |> Enum.map(&right/1) |> Enum.max()
  def right(items), do: x(items) + width(items)

  @spec right(Interface.t(), Float.t()) :: Interface.t()
  def right(items, value), do: x(items, value - width(items))

  @spec bottom(Interface.t() | list(Interface.t())) :: Float.t()
  def bottom(items) when is_list(items), do: items |> Enum.map(&bottom/1) |> Enum.max()
  def bottom(item), do: y(item) + height(item)

  @spec bottom(Interface.t(), Float.t()) :: Interface.t()
  def bottom(items, value), do: y(items, value - height(items))

  @spec surrounding_rect(list(Interface.t())) :: Graphics.Rect.t()
  def surrounding_rect(list) do
    rect(right(list) - left(list), bottom(list) - top(list), left(list), top(list))
  end

  # Transform
  # ---------------------------

  @spec transform(Interface.t(), transformation()) :: Interface.t()
  @spec transform(list(Interface.t()), transformation()) :: list(Interface.t())

  def transform(item, {:set_width, to}) when is_interface(item) do
    item |> width(to) |> height(height(item) / width(item) * to)
  end

  def transform(item, {:set_height, to}) when is_interface(item) do
    item |> height(to) |> width(width(item) / height(item) * to)
  end

  def transform(item, {name, _} = tr) when is_list(item) and name in [:set_height, :set_width] do
    item |> Enum.map(&transform(&1, tr))
  end

  def transform(items, {:align, opts}) when is_list(items) do
    opts
    |> Keyword.validate!([:left, :right, :bottom, :top])
    |> Enum.reduce(items, fn {direction, value}, acc ->
      case value do
        v when is_number(v) -> align_transform(direction, v, acc)
        true -> align_transform(direction, align_value(direction, acc), acc)
        _ -> acc
      end
    end)
  end

  def transform(items, {:spread_horizontal, width, opts}) when is_list(items) do
    opts = opts |> Keyword.validate!(x: 0, cols: length(items), gap: 0)
    col_width = width / opts[:cols]
    offset = col_width / 2

    items
    |> Enum.with_index()
    |> Enum.map_reduce(nil, fn {rect, index}, prev ->
      rect =
        rect
        |> center_x(opts[:x] + col_width * index + offset)
        |> push_right(prev, gap: opts[:gap])

      {rect, rect}
    end)
    |> elem(0)
  end

  def transform(items, {:spread_vertical, height, opts}) when is_list(items) do
    opts = opts |> Keyword.validate!(y: 0, rows: length(items), gap: 0)
    row_height = height / opts[:rows]
    offset = row_height / 2

    items
    |> Enum.with_index()
    |> Enum.map_reduce(nil, fn {rect, index}, prev ->
      rect =
        rect
        |> center_y(opts[:y] + row_height * index + offset)
        |> push_bottom(prev, gap: opts[:gap])

      {rect, rect}
    end)
    |> elem(0)
  end

  def transform(items, {:distribute_horizontal, width}) when is_list(items) do
    gap = (width - (items |> Enum.map(&width(&1)) |> Enum.sum())) / (length(items) - 1)
    items |> Enum.map_reduce(0, &{x(&1, &2), &2 + width(&1) + gap}) |> elem(0)
  end

  def transform(items, {:distribute_vertical, height}) when is_list(items) do
    gap = (height - (items |> Enum.map(&height(&1)) |> Enum.sum())) / (length(items) - 1)
    items |> Enum.map_reduce(0, &{y(&1, &2), &2 + height(&1) + gap}) |> elem(0)
  end

  def transform(items, {:flow_horizontal, opts}) when is_list(items) do
    opts = opts |> Keyword.validate!(x: 0, gap: 0)
    items |> Enum.map_reduce(opts[:x], &{x(&1, &2), &2 + width(&1) + opts[:gap]}) |> elem(0)
  end

  def transform(items, {:flow_vertical, opts}) when is_list(items) do
    opts = opts |> Keyword.validate!(y: 0, gap: 0)
    items |> Enum.map_reduce(opts[:y], &{y(&1, &2), &2 + height(&1) + opts[:gap]}) |> elem(0)
  end

  # Helpers

  defp align_value(:left, items), do: left(items)
  defp align_value(:right, items), do: right(items)
  defp align_value(:top, items), do: top(items)
  defp align_value(:bottom, items), do: bottom(items)

  defp align_transform(:left, value, items), do: items |> Enum.map(&x(&1, value))
  defp align_transform(:right, value, items), do: items |> Enum.map(&x(&1, value - width(&1)))
  defp align_transform(:bottom, value, items), do: items |> Enum.map(&y(&1, value - height(&1)))
  defp align_transform(:top, value, items), do: items |> Enum.map(&y(&1, value))
end
