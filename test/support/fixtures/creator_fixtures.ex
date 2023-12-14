defmodule Rocketsized.CreatorFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rocketsized.Creator` context.
  """

  @doc """
  Generate a country.
  """
  def country_fixture(attrs \\ %{}) do
    {:ok, country} =
      attrs
      |> Enum.into(%{
        flag: "some flag",
        code: "us",
        name: "some name"
      })
      |> Rocketsized.Creator.create_country()

    country
  end

  @doc """
  Generate a manufacturer.
  """
  def manufacturer_fixture(attrs \\ %{}) do
    {:ok, manufacturer} =
      attrs
      |> Enum.into(%{
        flag: "some flag",
        name: "some name"
      })
      |> Rocketsized.Creator.create_manufacturer()

    manufacturer
  end
end
