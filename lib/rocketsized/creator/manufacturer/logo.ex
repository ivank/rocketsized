defmodule Rocketsized.Manufacturer.Logo do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname() |> String.downcase()

    case Enum.member?(~w(.svg .png .jpg), file_extension) do
      true -> :ok
      false -> {:error, "invalid file type"}
    end
  end

  def storage_dir(_version, {_file, _scope}) do
    "uploads/orgs"
  end
end
