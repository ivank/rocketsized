defmodule Graphics.Interface do
  alias Graphics.Group
  alias Graphics.Rect
  alias Graphics.Sprite
  alias Graphics.Utils

  @type t() :: Group.t() | Rect.t() | Sprite.t()

  @doc """
  Creates an `%Graphics.Sprite{}`, which is used to track external data for a rect.

  ## Examples

      iex(1)> image = "my image"
      "my image"
      iex(2)> sprite(rect(10, 20), image)
      %Graphics.Sprite{
        rect: %Graphics.Rect{x: 0, y: 0, width: 10, height: 20},
        value: "my image"
      }

  """
  @spec sprite(Rect.t(), any()) :: Graphics.Sprite.t()
  def sprite(rect, value), do: %Sprite{rect: rect, value: value}

  @doc """
  Creates an `%Graphics.Rect{}`, a primitive used to track info about rectangles.
  It does not have any other attributes except its x, y, width and height

  ## Examples

      iex(1)> rect(10, 20, 2, 5)
      %Graphics.Rect{x: 2, y: 5, width: 10, height: 20}

      iex(2)> rect(10, 20)
      %Graphics.Rect{x: 0, y: 0, width: 10, height: 20}

  """
  @spec rect(Float.t(), Float.t(), Float.t(), Float.t()) :: Graphics.Rect.t()
  def rect(width, height, x \\ 0, y \\ 0), do: %Rect{x: x, y: y, width: width, height: height}

  @doc """
  Creates an `%Graphics.Group{}`, used to work with a group of graphical items.
  any modification of its x, y, width or height affects all of its children, proportionally.

  ## Examples

      iex(1)> group([rect(10,20),rect(5,5)])
      %Graphics.Group{
        rect: %Graphics.Rect{x: 0, y: 0, width: 10, height: 20},
        children: [
          %Graphics.Rect{x: 0, y: 0, width: 10, height: 20},
          %Graphics.Rect{x: 0, y: 0, width: 5, height: 5}
        ]
      }
  """
  @spec group(list(t())) :: Group.t()
  def group(children), do: %Group{rect: Utils.surrounding_rect(children), children: children}

  @doc """
  Update the children of a group.
  It will also will update the bounding rect of the group.

    ## Examples

      iex(1)> children(group([rect(10, 20), rect(5, 5)]), [rect(2, 2)])
      %Graphics.Group{
        rect: %Graphics.Rect{x: 0, y: 0, width: 2, height: 2},
        children: [
          %Graphics.Rect{x: 0, y: 0, width: 2, height: 2}
        ]
      }
  """
  @spec children(Group.t(), list(t())) :: Group.t()
  def children(%Group{} = group, children) do
    %{group | rect: Utils.surrounding_rect(children), children: children}
  end

  defguard is_rect(value) when is_struct(value, Rect)
  defguard is_sprite(value) when is_struct(value, Sprite)
  defguard is_group(value) when is_struct(value, Group)
  defguard is_interface(value) when is_rect(value) or is_sprite(value) or is_group(value)

  # Interface
  # ============================

  @spec x(t()) :: Float.t()
  def x(%Rect{x: x}), do: x
  def x(value), do: x(value.rect)

  @spec x(t(), Float.t()) :: t()
  def x(%Rect{} = rect, x), do: %{rect | x: x}
  def x(%Sprite{rect: rect} = sprite, x), do: %{sprite | rect: x(rect, x)}

  def x(%Group{rect: rect, children: children} = group, x) do
    delta = x - x(rect)
    %{group | rect: x(rect, x), children: Enum.map(children, &x(&1, x(&1) + delta))}
  end

  def y(%Rect{y: y}), do: y
  def y(value), do: y(value.rect)

  @spec y(t(), Float.t()) :: t()
  def y(%Rect{} = rect, y), do: %{rect | y: y}
  def y(%Sprite{rect: rect} = sprite, y), do: %{sprite | rect: y(rect, y)}

  def y(%Group{rect: rect, children: children} = group, y) do
    delta = y - y(rect)
    %{group | rect: y(rect, y), children: Enum.map(children, &y(&1, y(&1) + delta))}
  end

  @spec width(t()) :: Float.t()
  def width(%Rect{width: width}), do: width
  def width(value), do: width(value.rect)

  @spec width(t(), Float.t()) :: t()
  def width(%Rect{} = rect, width), do: %{rect | width: width}
  def width(%Sprite{rect: rect} = sprite, width), do: %{sprite | rect: width(rect, width)}

  def width(%Group{rect: rect, children: children} = group, width) do
    scale = width / width(rect)
    children = Enum.map(children, &(&1 |> x(x(&1) * scale) |> width(width(&1) * scale)))
    %{group | rect: width(rect, width), children: children}
  end

  @spec height(t()) :: Float.t()
  def height(%Rect{height: height}), do: height
  def height(value), do: height(value.rect)

  @spec height(t(), Float.t()) :: t()
  def height(%Rect{} = rect, height), do: %{rect | height: height}
  def height(%Sprite{rect: rect} = sprite, height), do: %{sprite | rect: height(rect, height)}

  def height(%Group{rect: rect, children: children} = group, height) do
    scale = height / height(rect)
    children = Enum.map(children, &(&1 |> y(y(&1) * scale) |> height(height(&1) * scale)))
    %{group | rect: height(rect, height), children: children}
  end

  # Derived
  # =================

  @spec center_x(t()) :: Float.t()
  def center_x(value), do: x(value) + width(value) / 2

  @spec center_x(t(), Float.t()) :: t()
  def center_x(value, x), do: value |> x(x - width(value) / 2)

  @spec center_y(t()) :: Float.t()
  def center_y(value), do: y(value) + height(value) / 2

  @spec center_y(t(), Float.t()) :: t()
  def center_y(value, y), do: value |> y(y - height(value) / 2)
end
