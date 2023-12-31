defmodule Rocketsized.Rocket.Vehicle.Image do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  alias Ecto.Changeset
  alias Rocketsized.Rocket.Vehicle.ImageMeta

  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname() |> String.downcase()

    case Enum.member?(~w(.svg .png), file_extension) do
      true -> :ok
      false -> {:error, "invalid file type"}
    end
  end

  def storage_dir(_version, {_file, _scope}) do
    "uploads/vehicle"
  end

  @spec cast_image_meta(Changeset.t(), atom(), atom()) :: Changeset.t()
  def cast_image_meta(%Changeset{} = changeset, field, embed_field) do
    if Changeset.changed?(changeset, field) do
      put_image_meta(changeset, field, embed_field)
    else
      changeset
    end
  end

  def storage_file_path({file, scope}, version \\ :original) do
    Path.join([storage_dir_prefix(), storage_dir(version, {file, scope}), file.file_name])
  end

  def put_image_meta(%Changeset{data: data} = changeset, field, embed_field) do
    file = Changeset.get_field(changeset, field)

    path = storage_file_path({file, data})

    case image_info(path) do
      {:ok, width, height, type} ->
        embed =
          (Changeset.get_field(changeset, embed_field) || %ImageMeta{})
          |> Changeset.change(%{width: width, height: height, type: type})

        Changeset.put_embed(changeset, embed_field, embed)

      _ ->
        Changeset.add_error(changeset, field, "could not fetch meta data for image")
    end
  end

  @spec image_info(Path.t()) ::
          nil | {:error, atom() | binary()} | {:ok, Float.t(), Float.t(), atom()}
  def image_info(file) do
    file_extension = file |> Path.extname() |> String.downcase()

    with {:ok, contents} <- File.read(file) do
      if file_extension == ".svg" do
        with {:ok, svg} <- Floki.parse_document(contents) do
          viewbox = svg |> Floki.attribute("svg", "viewbox") |> Floki.text() |> String.split(" ")

          width =
            svg |> Floki.attribute("svg", "width") |> Floki.text() |> to_pixels() ||
              viewbox |> Enum.at(2) |> to_pixels()

          height =
            svg |> Floki.attribute("svg", "height") |> Floki.text() |> to_pixels() ||
              viewbox |> Enum.at(3) |> to_pixels()

          {:ok, width, height, :svg}
        end
      else
        with {_, width, height, type} <- contents |> ExImageInfo.info(),
             {:ok, type} <- to_image_type(type) do
          {:ok, width, height, type}
        end
      end
    end
  end

  defp to_image_type("baseJPEG"), do: {:ok, :jpg}
  defp to_image_type("progJPEG"), do: {:ok, :jpg}
  defp to_image_type("JP2"), do: {:ok, :jpg}
  defp to_image_type("PNG"), do: {:ok, :png}
  defp to_image_type("webpVP8"), do: {:ok, :webp}
  defp to_image_type("webpVP8L"), do: {:ok, :webp}
  defp to_image_type("webpVP8X"), do: {:ok, :webp}
  defp to_image_type(_), do: :error

  defp to_pixels(value) do
    with {value, unit} <- Float.parse(value) do
      case unit do
        "px" -> value
        "in" -> value * 96
        "cm" -> value * 37.795
        "mm" -> value * 3.7795
        "pt" -> value * 1.3333
        "pc" -> value * 16
        _ -> value
      end
    else
      _ -> nil
    end
  end
end
