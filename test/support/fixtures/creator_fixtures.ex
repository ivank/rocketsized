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
        flag: %Plug.Upload{
          content_type: "image/svg",
          filename: "flag.svg",
          path: "test/support/fixtures/images/flag.svg"
        },
        code: "us",
        name: "some country",
        short_name: "soco"
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
        logo: %Plug.Upload{
          content_type: "image/svg",
          filename: "org.svg",
          path: "test/support/fixtures/images/org.svg"
        },
        name: "some org",
        short_name: "sorg",
        slug: "sorg"
      })
      |> Rocketsized.Creator.create_manufacturer()

    manufacturer
  end
end
