defmodule Rocketsized.RocketTest do
  use Rocketsized.DataCase

  alias Rocketsized.Rocket
  alias Rocketsized.Rocket.Vehicle.Image

  import Rocketsized.RocketFixtures
  import Rocketsized.CreatorFixtures

  defp create_flop_data(_) do
    country = country_fixture()
    manufacturer = manufacturer_fixture()

    other_country = country_fixture(%{code: "CN", name: "China"})
    other_manufacturer = manufacturer_fixture(%{name: "CSA", slug: "csa"})

    vehicles =
      for item <- 1..20 do
        vehicle_fixture(%{
          country_id: country.id,
          slug: "r#{item}",
          is_published: true,
          height: 100 - item,
          name: "rocket #{item}",
          vehicle_manufacturers: [
            %{manufacturer_id: manufacturer.id}
          ]
        })
      end

    other_vehicles =
      for item <- 1..20 do
        vehicle_fixture(%{
          country_id: other_country.id,
          is_published: true,
          slug: "o#{item}",
          height: 50 - item,
          name: "other rocket #{item}",
          vehicle_manufacturers: [
            %{manufacturer_id: other_manufacturer.id}
          ]
        })
      end

    flop = %Flop{
      filters: Flop.Filter.put_value([], :search, nil)
    }

    flop_vehicle = %Flop{
      filters: Flop.Filter.put_value([], :search, ["r_#{Enum.at(vehicles, 0).slug}"])
    }

    flop_country = %Flop{
      filters: Flop.Filter.put_value([], :search, ["c_#{country.code}"])
    }

    flop_other_country = %Flop{
      filters: Flop.Filter.put_value([], :search, ["c_#{other_country.code}"])
    }

    flop_manufacturer = %Flop{
      filters: Flop.Filter.put_value([], :search, ["o_#{manufacturer.slug}"])
    }

    %{
      vehicles: vehicles,
      country: country,
      manufacturer: manufacturer,
      other_vehicles: other_vehicles,
      other_country: other_country,
      other_manufacturer: other_manufacturer,
      flop: flop,
      flop_vehicle: flop_vehicle,
      flop_country: flop_country,
      flop_other_country: flop_other_country,
      flop_manufacturer: flop_manufacturer
    }
  end

  describe "families" do
    alias Rocketsized.Rocket.Family

    import Rocketsized.RocketFixtures

    @invalid_attrs %{name: nil}

    test "list_families/0 returns all families" do
      family = family_fixture()
      assert Rocket.list_families() == [family]
    end

    test "get_family!/1 returns the family with given id" do
      family = family_fixture()
      assert Rocket.get_family!(family.id) == family
    end

    test "create_family/1 with valid data creates a family" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Family{} = family} = Rocket.create_family(valid_attrs)
      assert family.name == "some name"
    end

    test "create_family/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rocket.create_family(@invalid_attrs)
    end

    test "update_family/2 with valid data updates the family" do
      family = family_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Family{} = family} = Rocket.update_family(family, update_attrs)
      assert family.name == "some updated name"
    end

    test "update_family/2 with invalid data returns error changeset" do
      family = family_fixture()
      assert {:error, %Ecto.Changeset{}} = Rocket.update_family(family, @invalid_attrs)
      assert family == Rocket.get_family!(family.id)
    end

    test "delete_family/1 deletes the family" do
      family = family_fixture()
      assert {:ok, %Family{}} = Rocket.delete_family(family)
      assert_raise Ecto.NoResultsError, fn -> Rocket.get_family!(family.id) end
    end

    test "change_family/1 returns a family changeset" do
      family = family_fixture()
      assert %Ecto.Changeset{} = Rocket.change_family(family)
    end
  end

  describe "vehicles" do
    alias Rocketsized.Rocket.Vehicle

    import Rocketsized.RocketFixtures

    @invalid_attrs %{name: nil}

    test "image_info should be able to parse image to get width and height, as well as image type" do
      dir = "test/support/fixtures/images"
      assert {:ok, 24.0, 24.0, :svg} = Image.image_info(Path.join(dir, "org.svg"))
      assert {:ok, 186, 88, :png} = Image.image_info(Path.join(dir, "d-logo.png"))
      assert {:ok, 24.0, 24.0, :svg} = Image.image_info(Path.join(dir, "flag.svg"))
      assert {:ok, 24.0, 24.0, :svg} = Image.image_info(Path.join(dir, "rocket.svg"))
      assert {:ok, 270.0, 270.0, :svg} = Image.image_info(Path.join(dir, "energia.svg"))
    end

    test "list_vehicles/0 returns all vehicles" do
      vehicle = vehicle_fixture()
      assert Rocket.list_vehicles() == [vehicle]
    end

    test "get_vehicle!/1 returns the vehicle with given id" do
      vehicle = vehicle_fixture()
      assert Rocket.get_vehicle!(vehicle.id) == vehicle
    end

    test "create_vehicle/1 with valid data creates a vehicle" do
      valid_attrs = %{
        name: "some name",
        image: %Plug.Upload{
          content_type: "image/svg+xml",
          filename: "org.svg",
          path: "test/support/fixtures/images/org.svg"
        }
      }

      assert {:ok, %Vehicle{} = vehicle} = Rocket.create_vehicle(valid_attrs)
      assert vehicle.name == "some name"
      assert vehicle.image_meta.width == 24
      assert vehicle.image_meta.height == 24
      assert vehicle.image_meta.type == :svg
    end

    test "create_vehicle/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rocket.create_vehicle(@invalid_attrs)
    end

    test "update_vehicle/2 with valid data updates the vehicle" do
      vehicle = vehicle_fixture()

      update_attrs = %{
        name: "some updated name",
        image: %Plug.Upload{
          content_type: "image/svg+xml",
          filename: "energia.svg",
          path: "test/support/fixtures/images/energia.svg"
        }
      }

      assert {:ok, %Vehicle{} = vehicle} = Rocket.update_vehicle(vehicle, update_attrs)
      assert vehicle.name == "some updated name"
      assert vehicle.image_meta.width == 270
      assert vehicle.image_meta.height == 270
      assert vehicle.image_meta.type == :svg
    end

    test "update_vehicle/2 with png populates image_meta" do
      vehicle = vehicle_fixture()

      update_attrs = %{
        image: %Plug.Upload{
          content_type: "image/png",
          filename: "d-logo.png",
          path: "test/support/fixtures/images/d-logo.png"
        }
      }

      assert {:ok, %Vehicle{} = vehicle} = Rocket.update_vehicle(vehicle, update_attrs)
      assert vehicle.image_meta.width == 186
      assert vehicle.image_meta.height == 88
      assert vehicle.image_meta.type == :png
    end

    test "update_vehicle/2 with invalid data returns error changeset" do
      vehicle = vehicle_fixture()
      assert {:error, %Ecto.Changeset{}} = Rocket.update_vehicle(vehicle, @invalid_attrs)
      assert vehicle == Rocket.get_vehicle!(vehicle.id)
    end

    test "delete_vehicle/1 deletes the vehicle" do
      vehicle = vehicle_fixture()
      assert {:ok, %Vehicle{}} = Rocket.delete_vehicle(vehicle)
      assert_raise Ecto.NoResultsError, fn -> Rocket.get_vehicle!(vehicle.id) end
    end

    test "change_vehicle/1 returns a vehicle changeset" do
      vehicle = vehicle_fixture()
      assert %Ecto.Changeset{} = Rocket.change_vehicle(vehicle)
    end

    test "list_vehicles_image_meta/0 returns a the correct ones" do
      vehicles = [
        vehicle_fixture(%{slug: "r1"}),
        vehicle_fixture(%{slug: "r2", image: nil, image_meta: nil}),
        vehicle_fixture(%{slug: "r3", image_meta: %{width: 30, height: 20, license: :rf}}),
        vehicle_fixture(%{slug: "r4", image: nil, image_meta: nil})
      ]

      assert Rocket.list_vehicles_image_meta() ==
               Enum.map(vehicles, &Rocket.to_vehicle_image_meta/1)
    end
  end

  describe "launches" do
    alias Rocketsized.Rocket.Launch

    import Rocketsized.RocketFixtures

    @invalid_attrs %{status: nil, launched_at: nil, details: nil}

    test "list_launches/0 returns all launches" do
      launch = launch_fixture()
      assert Rocket.list_launches() == [launch]
    end

    test "get_launch!/1 returns the launch with given id" do
      launch = launch_fixture()
      assert Rocket.get_launch!(launch.id) == launch
    end

    test "create_launch/1 with valid data creates a launch" do
      valid_attrs = %{
        status: :success,
        launched_at: ~U[2023-12-06 06:40:00Z],
        details: "some details"
      }

      assert {:ok, %Launch{} = launch} = Rocket.create_launch(valid_attrs)
      assert launch.status == :success
      assert launch.launched_at == ~U[2023-12-06 06:40:00Z]
      assert launch.details == "some details"
    end

    test "create_launch/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rocket.create_launch(@invalid_attrs)
    end

    test "update_launch/2 with valid data updates the launch" do
      launch = launch_fixture()

      update_attrs = %{
        status: :failure,
        launched_at: ~U[2023-12-07 06:40:00Z],
        details: "some updated details"
      }

      assert {:ok, %Launch{} = launch} = Rocket.update_launch(launch, update_attrs)
      assert launch.status == :failure
      assert launch.launched_at == ~U[2023-12-07 06:40:00Z]
      assert launch.details == "some updated details"
    end

    test "update_launch/2 with invalid data returns error changeset" do
      launch = launch_fixture()
      assert {:error, %Ecto.Changeset{}} = Rocket.update_launch(launch, @invalid_attrs)
      assert launch == Rocket.get_launch!(launch.id)
    end

    test "delete_launch/1 deletes the launch" do
      launch = launch_fixture()
      assert {:ok, %Launch{}} = Rocket.delete_launch(launch)
      assert_raise Ecto.NoResultsError, fn -> Rocket.get_launch!(launch.id) end
    end

    test "change_launch/1 returns a launch changeset" do
      launch = launch_fixture()
      assert %Ecto.Changeset{} = Rocket.change_launch(launch)
    end
  end

  describe "stages" do
    alias Rocketsized.Rocket.Stage

    import Rocketsized.RocketFixtures

    @invalid_attrs %{propellant: nil}

    test "list_stages/0 returns all stages" do
      stage = stage_fixture()
      assert Rocket.list_stages() == [stage]
    end

    test "get_stage!/1 returns the stage with given id" do
      stage = stage_fixture()
      assert Rocket.get_stage!(stage.id) == stage
    end

    test "create_stage/1 with valid data creates a stage" do
      valid_attrs = %{propellant: [:lox]}

      assert {:ok, %Stage{} = stage} = Rocket.create_stage(valid_attrs)
      assert stage.propellant == [:lox]
    end

    test "create_stage/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rocket.create_stage(@invalid_attrs)
    end

    test "update_stage/2 with valid data updates the stage" do
      stage = stage_fixture()
      update_attrs = %{propellant: [:rp1]}

      assert {:ok, %Stage{} = stage} = Rocket.update_stage(stage, update_attrs)
      assert stage.propellant == [:rp1]
    end

    test "update_stage/2 with invalid data returns error changeset" do
      stage = stage_fixture()
      assert {:error, %Ecto.Changeset{}} = Rocket.update_stage(stage, @invalid_attrs)
      assert stage == Rocket.get_stage!(stage.id)
    end

    test "delete_stage/1 deletes the stage" do
      stage = stage_fixture()
      assert {:ok, %Stage{}} = Rocket.delete_stage(stage)
      assert_raise Ecto.NoResultsError, fn -> Rocket.get_stage!(stage.id) end
    end

    test "change_stage/1 returns a stage changeset" do
      stage = stage_fixture()
      assert %Ecto.Changeset{} = Rocket.change_stage(stage)
    end
  end

  describe "motors" do
    alias Rocketsized.Rocket.Motor

    import Rocketsized.RocketFixtures

    @invalid_attrs %{
      cycle: nil,
      isp_space: nil,
      isp_sea: nil,
      thrust: nil,
      chamber_pressure: nil,
      weight: nil
    }

    test "list_motors/0 returns all motors" do
      motor = motor_fixture()
      assert Rocket.list_motors() == [motor]
    end

    test "get_motor!/1 returns the motor with given id" do
      motor = motor_fixture()
      assert Rocket.get_motor!(motor.id) == motor
    end

    test "create_motor/1 with valid data creates a motor" do
      valid_attrs = %{
        cycle: :gas_generator,
        isp_space: 120.5,
        isp_sea: 120.5,
        thrust: 120.5,
        chamber_pressure: 120.5,
        weight: 120.5
      }

      assert {:ok, %Motor{} = motor} = Rocket.create_motor(valid_attrs)
      assert motor.cycle == :gas_generator
      assert motor.isp_space == 120.5
      assert motor.isp_sea == 120.5
      assert motor.thrust == 120.5
      assert motor.chamber_pressure == 120.5
      assert motor.weight == 120.5
    end

    test "create_motor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rocket.create_motor(@invalid_attrs)
    end

    test "update_motor/2 with valid data updates the motor" do
      motor = motor_fixture()

      update_attrs = %{
        cycle: :full_flow_staged_combustion,
        isp_space: 456.7,
        isp_sea: 456.7,
        thrust: 456.7,
        chamber_pressure: 456.7,
        weight: 456.7
      }

      assert {:ok, %Motor{} = motor} = Rocket.update_motor(motor, update_attrs)
      assert motor.cycle == :full_flow_staged_combustion
      assert motor.isp_space == 456.7
      assert motor.isp_sea == 456.7
      assert motor.thrust == 456.7
      assert motor.chamber_pressure == 456.7
      assert motor.weight == 456.7
    end

    test "update_motor/2 with invalid data returns error changeset" do
      motor = motor_fixture()
      assert {:error, %Ecto.Changeset{}} = Rocket.update_motor(motor, @invalid_attrs)
      assert motor == Rocket.get_motor!(motor.id)
    end

    test "delete_motor/1 deletes the motor" do
      motor = motor_fixture()
      assert {:ok, %Motor{}} = Rocket.delete_motor(motor)
      assert_raise Ecto.NoResultsError, fn -> Rocket.get_motor!(motor.id) end
    end

    test "change_motor/1 returns a motor changeset" do
      motor = motor_fixture()
      assert %Ecto.Changeset{} = Rocket.change_motor(motor)
    end
  end

  describe "search_slug" do
    test "search_slugs/1 should search for slugs" do
      country = country_fixture(%{name: "Canada", code: "ca"})

      vehicle =
        vehicle_fixture(%{
          name: "Falcon Heavy",
          slug: "fh",
          is_published: true,
          country_id: country.id
        })

      org = manufacturer_fixture(%{name: "Space X", slug: "spacex"})

      search1 = Rocket.search_slugs(["c_ca"])
      search2 = Rocket.search_slugs(["c_ca", "r_fh", "o_spacex"])

      assert Enum.at(search1, 0).subtitle == country.name
      assert Enum.find(search2, &(&1.slug == "ca")).subtitle == country.name
      assert Enum.find(search2, &(&1.slug == "fh")).title == vehicle.name
      assert Enum.find(search2, &(&1.slug == "spacex")).subtitle == org.name
    end

    test "search_slugs_query/1 should search for slugs" do
      country = country_fixture(%{name: "Canada", code: "ca"})

      vehicle =
        vehicle_fixture(%{
          name: "Falcon Heavy",
          slug: "fh",
          is_published: true,
          country_id: country.id
        })

      org = manufacturer_fixture(%{name: "Space X", slug: "spacex"})

      search1 = Rocket.search_slugs_query("Canada")
      search2 = Rocket.search_slugs_query("Space X")
      search3 = Rocket.search_slugs_query("Falcon Heavy")

      assert Enum.at(search1, 0).subtitle == country.name
      assert Enum.at(search2, 0).subtitle == org.name
      assert Enum.at(search3, 0).title == vehicle.name
    end
  end

  describe "flop" do
    setup [:create_flop_data]

    test "flop_vehicles_grid/1 should return vehicles based on flop", %{
      vehicles: vehicles,
      other_vehicles: other_vehicles,
      flop: flop,
      flop_vehicle: flop_vehicle,
      flop_country: flop_country,
      flop_manufacturer: flop_manufacturer
    } do
      assert Rocket.flop_vehicles_grid(flop) |> elem(0) |> length() ==
               length(vehicles) + length(other_vehicles)

      assert Rocket.flop_vehicles_grid(flop_vehicle) |> elem(0) |> length() == 1

      assert Rocket.flop_vehicles_grid(flop_country) |> elem(0) |> length() == length(vehicles)

      assert Rocket.flop_vehicles_grid(flop_manufacturer) |> elem(0) |> length() ==
               length(vehicles)
    end

    test "flop_vehicles_max_height/1 should return max height based on flop", %{
      flop: flop,
      flop_vehicle: flop_vehicle,
      flop_country: flop_country,
      flop_manufacturer: flop_manufacturer,
      flop_other_country: flop_other_country
    } do
      assert Rocket.flop_vehicles_max_height(flop) == 99.0
      assert Rocket.flop_vehicles_max_height(flop_vehicle) == 99.0
      assert Rocket.flop_vehicles_max_height(flop_country) == 99.0
      assert Rocket.flop_vehicles_max_height(flop_manufacturer) == 99.0
      assert Rocket.flop_vehicles_max_height(flop_other_country) == 49.0
    end

    test "flop_vehicles_file/1 should return vehicles based on flop", %{
      vehicles: vehicles,
      other_vehicles: other_vehicles,
      flop: flop,
      flop_vehicle: flop_vehicle,
      flop_country: flop_country,
      flop_manufacturer: flop_manufacturer
    } do
      assert Rocket.flop_vehicles_file(flop) |> elem(0) |> length() ==
               length(vehicles) + length(other_vehicles)

      assert Rocket.flop_vehicles_file(flop_vehicle) |> elem(0) |> length() == 1

      assert Rocket.flop_vehicles_file(flop_country) |> elem(0) |> length() == length(vehicles)

      assert Rocket.flop_vehicles_file(flop_manufacturer) |> elem(0) |> length() ==
               length(vehicles)
    end

    test "flop_vehicles_title/1 should return title on flop", %{
      flop: flop,
      flop_vehicle: flop_vehicle,
      flop_country: flop_country,
      flop_manufacturer: flop_manufacturer
    } do
      assert Rocket.flop_vehicles_title(flop, "all") == "all"
      assert Rocket.flop_vehicles_title(flop_vehicle) == "rocket 1"
      assert Rocket.flop_vehicles_title(flop_country) == "from soco"
      assert Rocket.flop_vehicles_title(flop_manufacturer) == "by sorg"
    end
  end
end
