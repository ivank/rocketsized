defmodule Rocketsized.CreatorTest do
  use Rocketsized.DataCase

  alias Rocketsized.Creator

  describe "countries" do
    alias Rocketsized.Creator.Country

    import Rocketsized.CreatorFixtures

    @invalid_attrs %{name: nil, flag: nil}

    test "list_countries/0 returns all countries" do
      country = country_fixture()
      assert Creator.list_countries() == [country]
    end

    test "get_country!/1 returns the country with given id" do
      country = country_fixture()
      assert Creator.get_country!(country.id) == country
    end

    test "create_country/1 with valid data creates a country" do
      valid_attrs = %{
        name: "some name",
        code: "us",
        short_name: "some short",
        flag: %Plug.Upload{
          content_type: "image/svg",
          filename: "org.svg",
          path: "test/support/fixtures/images/org.svg"
        }
      }

      assert {:ok, %Country{} = country} = Creator.create_country(valid_attrs)
      assert country.name == "some name"
      assert country.short_name == "some short"
      assert country.flag.file_name == "org.svg"
    end

    test "create_country/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Creator.create_country(@invalid_attrs)
    end

    test "update_country/2 with valid data updates the country" do
      country = country_fixture()
      update_attrs = %{name: "some updated name", short_name: "some updated short"}

      assert {:ok, %Country{} = country} = Creator.update_country(country, update_attrs)
      assert country.name == "some updated name"
      assert country.short_name == "some updated short"
    end

    test "update_country/2 with invalid data returns error changeset" do
      country = country_fixture()
      assert {:error, %Ecto.Changeset{}} = Creator.update_country(country, @invalid_attrs)
      assert country == Creator.get_country!(country.id)
    end

    test "delete_country/1 deletes the country" do
      country = country_fixture()
      assert {:ok, %Country{}} = Creator.delete_country(country)
      assert_raise Ecto.NoResultsError, fn -> Creator.get_country!(country.id) end
    end

    test "change_country/1 returns a country changeset" do
      country = country_fixture()
      assert %Ecto.Changeset{} = Creator.change_country(country)
    end
  end

  describe "manufacturers" do
    alias Rocketsized.Creator.Manufacturer

    import Rocketsized.CreatorFixtures

    @invalid_attrs %{name: nil, flag: nil}

    test "list_manufacturers/0 returns all manufacturers" do
      manufacturer = manufacturer_fixture()
      assert Creator.list_manufacturers() == [manufacturer]
    end

    test "get_manufacturer!/1 returns the manufacturer with given id" do
      manufacturer = manufacturer_fixture()
      assert Creator.get_manufacturer!(manufacturer.id) == manufacturer
    end

    test "create_manufacturer/1 with valid data creates a manufacturer" do
      valid_attrs = %{
        name: "some name",
        short_name: "some short",
        slug: "sm",
        logo: %Plug.Upload{
          content_type: "image/svg",
          filename: "flag.svg",
          path: "test/support/fixtures/images/flag.svg"
        }
      }

      assert {:ok, %Manufacturer{} = manufacturer} = Creator.create_manufacturer(valid_attrs)
      assert manufacturer.name == "some name"
      assert manufacturer.short_name == "some short"
      assert manufacturer.logo.file_name == "flag.svg"
    end

    test "create_manufacturer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Creator.create_manufacturer(@invalid_attrs)
    end

    test "update_manufacturer/2 with valid data updates the manufacturer" do
      manufacturer = manufacturer_fixture()

      update_attrs = %{
        name: "some updated name",
        short_name: "some updated short name",
        logo: %Plug.Upload{
          content_type: "image/svg",
          filename: "flag.svg",
          path: "test/support/fixtures/images/flag.svg"
        }
      }

      assert {:ok, %Manufacturer{} = manufacturer} =
               Creator.update_manufacturer(manufacturer, update_attrs)

      assert manufacturer.name == "some updated name"
      assert manufacturer.short_name == "some updated short name"
      assert manufacturer.logo.file_name == "flag.svg"
    end

    test "update_manufacturer/2 with invalid data returns error changeset" do
      manufacturer = manufacturer_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Creator.update_manufacturer(manufacturer, @invalid_attrs)

      assert manufacturer == Creator.get_manufacturer!(manufacturer.id)
    end

    test "delete_manufacturer/1 deletes the manufacturer" do
      manufacturer = manufacturer_fixture()
      assert {:ok, %Manufacturer{}} = Creator.delete_manufacturer(manufacturer)
      assert_raise Ecto.NoResultsError, fn -> Creator.get_manufacturer!(manufacturer.id) end
    end

    test "change_manufacturer/1 returns a manufacturer changeset" do
      manufacturer = manufacturer_fixture()
      assert %Ecto.Changeset{} = Creator.change_manufacturer(manufacturer)
    end
  end
end
