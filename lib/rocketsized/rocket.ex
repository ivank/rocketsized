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
    from(v in Vehicle, where: v.is_published, order_by: [desc: v.height], limit: 12)
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
    delete_all_renders()

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
    delete_all_renders()

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
    delete_all_renders()

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

  @spec flop_vehicles_grid(Flop.t()) :: {list(), Flop.Meta.t()}
  def flop_vehicles_grid(%Flop{} = flop) do
    opts = [for: Vehicle]
    flop_vehicle_query(flop, opts) |> preload([:manufacturers, :country]) |> Flop.run(flop, opts)
  end

  @spec flop_vehicles_max_height(Flop.t()) :: number()
  def flop_vehicles_max_height(%Flop{} = flop) do
    opts = [for: Vehicle]

    from(v in Vehicle, where: v.is_published == true, select: max(v.height))
    |> Flop.with_named_bindings(flop, &join_vehicle_assoc/2, opts)
    |> Flop.query(Flop.reset_order(flop), opts)
    |> Repo.one()
  end

  @spec flop_vehicles_file(Flop.t()) :: {list(), Flop.Meta.t()}
  def flop_vehicles_file(%Flop{} = flop) do
    opts = [for: Vehicle, default_limit: false, pagination: false]
    reset_flop = Flop.reset_cursors(%{flop | first: nil})
    flop_vehicle_query(reset_flop, opts) |> preload([:country]) |> Flop.run(reset_flop, opts)
  end

  def flop_vehicles_title(%Flop{} = flop, default \\ "") do
    with slugs = [_ | _] <- Flop.Filter.get_value(flop.filters, :search),
         items = [_ | _] <- search_slugs(slugs) do
      for {type, filters} <- items |> Enum.group_by(& &1.type) do
        filters_title = filters |> Enum.map(& &1.title) |> Enum.join(", ")

        case type do
          :country -> "from #{filters_title}"
          :rocket -> "#{filters_title}"
          :org -> "by #{filters_title}"
        end
      end
      |> Enum.join(" or ")
    else
      _ -> default
    end
  end

  defp flop_vehicle_query(%Flop{} = flop, opts) do
    from(v in Vehicle, where: v.is_published == true, group_by: v.id)
    |> Flop.with_named_bindings(flop, &join_vehicle_assoc/2, opts)
  end

  defp join_vehicle_assoc(query, :vehicle_manufacturers) do
    join(query, :inner, [v], assoc(v, :vehicle_manufacturers), as: :vehicle_manufacturers)
  end

  defp join_vehicle_assoc(query, :manufacturers) do
    join(query, :inner, [v], assoc(v, :manufacturers), as: :manufacturers)
  end

  defp join_vehicle_assoc(query, :country) do
    join(query, :inner, [v], assoc(v, :country), as: :country)
  end

  @spec vehicles_attribution_list(list(%{image_meta: %{attribution: String.t()}})) :: String.t()
  def vehicles_attribution_list(vehicles) do
    vehicles
    |> Enum.map(& &1.image_meta.attribution)
    |> Enum.filter(& &1)
    |> Enum.map(&Floki.text(Floki.parse_document!(&1)))
    |> Enum.uniq()
    |> Enum.join(", ")
  end

  alias Rocketsized.Rocket.Render
  alias RocketsizedWeb.RenderComponent

  def flop_render_find_or_create(%Flop{filters: filters} = flop, type) do
    search = Flop.Filter.get_value(filters, :search) || []
    render = from(r in Render, where: r.type == ^type and r.filters == ^search) |> Repo.one()

    if render do
      render
    else
      title = flop_vehicles_title(flop, "of the world") |> String.replace(",", " ")
      filename = "Rockets #{title} #{type}.svg"
      image = %{filename: filename, binary: flop_render_binary(flop, type)}

      {:ok, render} =
        %Render{}
        |> Render.changeset(%{type: type, filters: search, image: image})
        |> Repo.insert()

      render
    end
  end

  @spec flop_render_binary(Flop.t(), :landscape | :portrait | :wallpaper) ::
          binary()
  def flop_render_binary(%Flop{} = flop, type) do
    {rockets, _meta} = flop_vehicles_file(flop)
    title = "Rockets #{flop_vehicles_title(flop, "of the world")}"
    credit = vehicles_attribution_list(rockets)

    {width, height} =
      case type do
        :portrait -> {2480, 3508}
        :landscape -> {3508, 2480}
        :wallpaper -> {3840, 2160}
      end

    attributes =
      RenderComponent.positions(rockets,
        title: title,
        credit: credit,
        width: width,
        height: height
      )

    RenderComponent.poster(Enum.into(attributes, %{}))
    |> Phoenix.HTML.Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  def delete_all_renders() do
    Repo.delete_all(Render)
  end

  alias Rocketsized.Rocket.SearchSlug

  def search_slugs_query(q) do
    from(vh in SearchSlug,
      where: ilike(vh.title, ^"#{q}%"),
      or_where: ilike(vh.subtitle, ^"#{q}%"),
      limit: 10
    )
    |> Repo.all()
  end

  @spec search_slugs(list(String.t())) :: list(SearchSlug.t())
  def search_slugs([_ | _] = slugs) do
    groups =
      slugs
      |> Enum.map(&SearchSlug.Type.load!(&1))
      |> Enum.group_by(& &1.type, & &1.slug)
      |> Enum.map(fn {type, slugs} ->
        dynamic([s], s.type == ^type and s.slug in ^slugs)
      end)
      |> Enum.reduce(fn group, query -> dynamic([_], ^query or ^group) end)

    from(s in SearchSlug, where: ^groups, limit: 20) |> Repo.all()
  end

  def search_slugs(_), do: []

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
