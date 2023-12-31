defmodule Rocketsized.Rocket do
  @moduledoc """
  The Rocket context.
  """

  import Ecto.Query, warn: false
  alias Rocketsized.Repo

  alias Rocketsized.Rocket.Family

  @doc """
  Returns the list of families.

  ## Examples

      iex> list_families()
      [%Family{}, ...]

  """
  def list_families do
    Repo.all(Family)
  end

  @doc """
  Gets a single family.

  Raises `Ecto.NoResultsError` if the Family does not exist.

  ## Examples

      iex> get_family!(123)
      %Family{}

      iex> get_family!(456)
      ** (Ecto.NoResultsError)

  """
  def get_family!(id), do: Repo.get!(Family, id)

  @doc """
  Creates a family.

  ## Examples

      iex> create_family(%{field: value})
      {:ok, %Family{}}

      iex> create_family(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_family(attrs \\ %{}) do
    %Family{}
    |> Family.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a family.

  ## Examples

      iex> update_family(family, %{field: new_value})
      {:ok, %Family{}}

      iex> update_family(family, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_family(%Family{} = family, attrs) do
    family
    |> Family.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a family.

  ## Examples

      iex> delete_family(family)
      {:ok, %Family{}}

      iex> delete_family(family)
      {:error, %Ecto.Changeset{}}

  """
  def delete_family(%Family{} = family) do
    Repo.delete(family)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking family changes.

  ## Examples

      iex> change_family(family)
      %Ecto.Changeset{data: %Family{}}

  """
  def change_family(%Family{} = family, attrs \\ %{}) do
    Family.changeset(family, attrs)
  end

  alias Rocketsized.Rocket.Vehicle

  @doc """
  Returns the list of vehicles.

  ## Examples

      iex> list_vehicles()
      [%Vehicle{}, ...]

  """
  def list_vehicles do
    Repo.all(Vehicle)
  end

  def list_vehicles_country do
    Repo.all(Vehicle) |> Repo.preload([:country])
  end

  def list_vehicles_poster do
    from(v in Vehicle, where: v.is_published, order_by: [desc: v.height])
    |> Repo.all()
    |> Repo.preload([:country])
  end

  @doc """
  Gets a single vehicle.

  Raises `Ecto.NoResultsError` if the Vehicle does not exist.

  ## Examples

      iex> get_vehicle!(123)
      %Vehicle{}

      iex> get_vehicle!(456)
      ** (Ecto.NoResultsError)

  """
  def get_vehicle!(id), do: Repo.get!(Vehicle, id)

  def get_vehicle_with_data!(id) do
    Repo.get!(Vehicle, id) |> Repo.preload([:country, :manufacturers, :vehicle_manufacturers])
  end

  @doc """
  Creates a vehicle.

  ## Examples

      iex> create_vehicle(%{field: value})
      {:ok, %Vehicle{}}

      iex> create_vehicle(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_vehicle(attrs \\ %{}) do
    %Vehicle{}
    |> Vehicle.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a vehicle.

  ## Examples

      iex> update_vehicle(vehicle, %{field: new_value})
      {:ok, %Vehicle{}}

      iex> update_vehicle(vehicle, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_vehicle(%Vehicle{} = vehicle, attrs) do
    vehicle
    |> Vehicle.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a vehicle.

  ## Examples

      iex> delete_vehicle(vehicle)
      {:ok, %Vehicle{}}

      iex> delete_vehicle(vehicle)
      {:error, %Ecto.Changeset{}}

  """
  def delete_vehicle(%Vehicle{} = vehicle) do
    Repo.delete(vehicle)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking vehicle changes.

  ## Examples

      iex> change_vehicle(vehicle)
      %Ecto.Changeset{data: %Vehicle{}}

  """
  def change_vehicle(%Vehicle{} = vehicle, attrs \\ %{}) do
    Vehicle.changeset(vehicle, attrs)
  end

  alias Rocketsized.Rocket.Launch

  @doc """
  Returns the list of launches.

  ## Examples

      iex> list_launches()
      [%Launch{}, ...]

  """
  def list_launches do
    Repo.all(Launch)
  end

  @doc """
  Gets a single launch.

  Raises `Ecto.NoResultsError` if the Launch does not exist.

  ## Examples

      iex> get_launch!(123)
      %Launch{}

      iex> get_launch!(456)
      ** (Ecto.NoResultsError)

  """
  def get_launch!(id), do: Repo.get!(Launch, id)

  @doc """
  Creates a launch.

  ## Examples

      iex> create_launch(%{field: value})
      {:ok, %Launch{}}

      iex> create_launch(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_launch(attrs \\ %{}) do
    %Launch{}
    |> Launch.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a launch.

  ## Examples

      iex> update_launch(launch, %{field: new_value})
      {:ok, %Launch{}}

      iex> update_launch(launch, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_launch(%Launch{} = launch, attrs) do
    launch
    |> Launch.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a launch.

  ## Examples

      iex> delete_launch(launch)
      {:ok, %Launch{}}

      iex> delete_launch(launch)
      {:error, %Ecto.Changeset{}}

  """
  def delete_launch(%Launch{} = launch) do
    Repo.delete(launch)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking launch changes.

  ## Examples

      iex> change_launch(launch)
      %Ecto.Changeset{data: %Launch{}}

  """
  def change_launch(%Launch{} = launch, attrs \\ %{}) do
    Launch.changeset(launch, attrs)
  end

  alias Rocketsized.Rocket.Stage

  @doc """
  Returns the list of stages.

  ## Examples

      iex> list_stages()
      [%Stage{}, ...]

  """
  def list_stages do
    Repo.all(Stage)
  end

  @doc """
  Gets a single stage.

  Raises `Ecto.NoResultsError` if the Stage does not exist.

  ## Examples

      iex> get_stage!(123)
      %Stage{}

      iex> get_stage!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stage!(id), do: Repo.get!(Stage, id)

  @doc """
  Creates a stage.

  ## Examples

      iex> create_stage(%{field: value})
      {:ok, %Stage{}}

      iex> create_stage(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stage(attrs \\ %{}) do
    %Stage{}
    |> Stage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a stage.

  ## Examples

      iex> update_stage(stage, %{field: new_value})
      {:ok, %Stage{}}

      iex> update_stage(stage, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_stage(%Stage{} = stage, attrs) do
    stage
    |> Stage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a stage.

  ## Examples

      iex> delete_stage(stage)
      {:ok, %Stage{}}

      iex> delete_stage(stage)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stage(%Stage{} = stage) do
    Repo.delete(stage)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stage changes.

  ## Examples

      iex> change_stage(stage)
      %Ecto.Changeset{data: %Stage{}}

  """
  def change_stage(%Stage{} = stage, attrs \\ %{}) do
    Stage.changeset(stage, attrs)
  end

  alias Rocketsized.Rocket.Motor

  @doc """
  Returns the list of motors.

  ## Examples

      iex> list_motors()
      [%Motor{}, ...]

  """
  def list_motors do
    Repo.all(Motor)
  end

  @doc """
  Gets a single motor.

  Raises `Ecto.NoResultsError` if the Motor does not exist.

  ## Examples

      iex> get_motor!(123)
      %Motor{}

      iex> get_motor!(456)
      ** (Ecto.NoResultsError)

  """
  def get_motor!(id), do: Repo.get!(Motor, id)

  @doc """
  Creates a motor.

  ## Examples

      iex> create_motor(%{field: value})
      {:ok, %Motor{}}

      iex> create_motor(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_motor(attrs \\ %{}) do
    %Motor{}
    |> Motor.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a motor.

  ## Examples

      iex> update_motor(motor, %{field: new_value})
      {:ok, %Motor{}}

      iex> update_motor(motor, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_motor(%Motor{} = motor, attrs) do
    motor
    |> Motor.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a motor.

  ## Examples

      iex> delete_motor(motor)
      {:ok, %Motor{}}

      iex> delete_motor(motor)
      {:error, %Ecto.Changeset{}}

  """
  def delete_motor(%Motor{} = motor) do
    Repo.delete(motor)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking motor changes.

  ## Examples

      iex> change_motor(motor)
      %Ecto.Changeset{data: %Motor{}}

  """
  def change_motor(%Motor{} = motor, attrs \\ %{}) do
    Motor.changeset(motor, attrs)
  end

  def list_vehicles_with_params(params) do
    opts = [for: Vehicle]

    with {:ok, %Flop{} = flop} <- Flop.validate(params, opts) do
      {data, meta} = list_vehicles_with_flop(flop)
      max_height = max_height_vehicles_with_flop(flop)

      {:ok, {data, meta, max_height}}
    end
  end

  def max_height_vehicles_with_flop(%Flop{} = flop) do
    opts = [for: Vehicle]

    from(p in Vehicle, where: p.is_published == true, select: max(p.height))
    |> Flop.with_named_bindings(flop, &join_vehicle_assoc/2, opts)
    |> Flop.query(flop |> Flop.reset_order(), opts)
    |> Repo.one()
  end

  def list_vehicles_with_flop(%Flop{} = flop) do
    opts = [for: Vehicle]

    from(p in Vehicle,
      where: p.is_published == true,
      order_by: [desc: p.height],
      group_by: p.id,
      preload: [:manufacturers, :country]
    )
    |> Flop.with_named_bindings(flop, &join_vehicle_assoc/2, opts)
    |> Flop.run(flop, opts)
  end

  defp join_vehicle_assoc(query, :vehicle_manufacturers) do
    join(query, :inner, [v], assoc(v, :vehicle_manufacturers), as: :vehicle_manufacturers)
  end

  defp join_vehicle_assoc(query, :manufacturers) do
    join(query, :inner, [v], assoc(v, :manufacturers), as: :manufacturers)
  end

  alias Rocketsized.Rocket.VehicleFilter

  def list_vehicle_filters_by_query(q) do
    from(vh in VehicleFilter,
      where: ilike(vh.title, ^"#{q}%"),
      or_where: ilike(vh.subtitle, ^"#{q}%"),
      limit: 10
    )
    |> Repo.all()
  end

  @spec list_vehicle_filters_by_ids(list(String.t())) :: list(VehicleFilter.t())
  def list_vehicle_filters_by_ids(ids) do
    groups =
      ids
      |> Enum.map(&VehicleFilter.Type.load(&1))
      |> VehicleFilter.Type.to_valid_list()
      |> Enum.group_by(& &1.type, & &1.id)
      |> Enum.map(fn {type, ids} ->
        dynamic([vf], vf.type == ^type and vf.id in ^ids)
      end)
      |> Enum.reduce(fn group, query -> dynamic([_], ^query or ^group) end)

    from(vf in VehicleFilter, where: ^groups, limit: 20) |> Repo.all()
  end

  @spec vehicle_filters_title_for_flop(Flop.t()) :: String.t() | nil
  def vehicle_filters_title_for_flop(%Flop{} = flop) do
    with %Flop{filters: filters} <- flop,
         [%Flop.Filter{value: value}] <- filters,
         ids = [_ | _] <- value,
         items = [_ | _] <- list_vehicle_filters_by_ids(ids) do
      for {type, filters} <- items |> Enum.group_by(& &1.type) do
        filters_title = filters |> Enum.map(& &1.title) |> Enum.join(", ")

        case type do
          :country -> "From #{filters_title}"
          :vehicle -> "#{filters_title}"
          :manufacturer -> "By #{filters_title}"
        end
      end
      |> Enum.join(" or ")
    else
      _ -> nil
    end
  end

  def list_vehicles_image_meta() do
    from(v in Vehicle,
      select: %{
        id: v.id,
        name: v.name,
        image?: not is_nil(v.image),
        image_meta?: not is_nil(v.image_meta)
      },
      order_by: [asc: v.id]
    )
    |> Repo.all()
  end

  def list_vehicles_image_meta_missing() do
    from(v in Vehicle,
      order_by: [asc: v.id],
      where: not is_nil(v.image) and is_nil(v.image_meta)
    )
    |> Repo.all()
  end

  def to_vehicle_image_meta(v) do
    %{id: v.id, name: v.name, image?: not is_nil(v.image), image_meta?: not is_nil(v.image_meta)}
  end

  def put_new_vehicle_image_meta(%Vehicle{} = vehicle) do
    changeset =
      vehicle |> Vehicle.changeset(%{}) |> Vehicle.Image.put_image_meta(:image, :image_meta)

    with {:ok, updated} <- changeset |> Repo.update() do
      {:ok, updated |> to_vehicle_image_meta()}
    end
  end
end
