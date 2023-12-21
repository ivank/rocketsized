defmodule Rocketsized.Rocket.Vehicle.Image do
  use Waffle.Definition
  use Waffle.Ecto.Definition

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
end
