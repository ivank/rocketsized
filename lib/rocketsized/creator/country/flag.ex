defmodule Rocketsized.Creator.Country.Flag do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname() |> String.downcase()

    case Enum.member?(~w(.svg), file_extension) do
      true -> :ok
      false -> {:error, "invalid file type"}
    end
  end

  def storage_dir(_version, {_file, _scope}) do
    "uploads/country"
  end

  def storage_file_path({file, scope}, version \\ :original) do
    Path.join([storage_dir_prefix(), storage_dir(version, {file, scope}), file.file_name])
  end
end
