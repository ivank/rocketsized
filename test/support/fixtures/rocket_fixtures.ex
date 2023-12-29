defmodule Rocketsized.RocketFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rocketsized.Rocket` context.
  """

  @doc """
  Generate a family.
  """
  def family_fixture(attrs \\ %{}) do
    {:ok, family} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Rocketsized.Rocket.create_family()

    family
  end

  @doc """
  Generate a vehicle.
  """
  def vehicle_fixture(attrs \\ %{}) do
    {:ok, vehicle} =
      %{
        name: "rocket",
        native_name: "ракета",
        alternative_name: "BFR",
        source: "https://example.com",
        height: 10,
        image: %Plug.Upload{
          content_type: "image/svg",
          filename: "rocket.svg",
          path: "test/support/fixtures/images/rocket.svg"
        },
        image_meta: %{
          width: 10.0,
          height: 10.0,
          type: :svg,
          license: :ivan_kerin,
          attribution: "Test"
        },
        diameter: 2,
        state: :operational
      }
      |> Map.merge(attrs)
      |> Rocketsized.Rocket.create_vehicle()

    vehicle
  end

  @doc """
  Generate a launch.
  """
  def launch_fixture(attrs \\ %{}) do
    {:ok, launch} =
      attrs
      |> Enum.into(%{
        details: "some details",
        launched_at: ~U[2023-12-06 06:40:00Z],
        status: :success
      })
      |> Rocketsized.Rocket.create_launch()

    launch
  end

  @doc """
  Generate a stage.
  """
  def stage_fixture(attrs \\ %{}) do
    {:ok, stage} =
      attrs
      |> Enum.into(%{
        propellant: [:hydrazine]
      })
      |> Rocketsized.Rocket.create_stage()

    stage
  end

  @doc """
  Generate a motor.
  """
  def motor_fixture(attrs \\ %{}) do
    {:ok, motor} =
      attrs
      |> Enum.into(%{
        chamber_pressure: 120.5,
        cycle: :gas_generator,
        isp_sea: 120.5,
        isp_space: 120.5,
        thrust: 120.5,
        weight: 120.5
      })
      |> Rocketsized.Rocket.create_motor()

    motor
  end
end
