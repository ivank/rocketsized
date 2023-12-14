defmodule Rocketsized.Datasource.Wikipedia do
  use Crawly.Spider
  alias Rocketsized.Datasource.WikipediaVehicle
  require Logger
  import Crawly.Utils

  @impl Crawly.Spider
  @spec base_url() :: String.t()
  def base_url(), do: "https://en.wikipedia.org/"

  @impl Crawly.Spider
  def init() do
    [start_urls: ["https://en.wikipedia.org/wiki/List_of_orbital_launch_systems"]]
  end

  @impl Crawly.Spider
  def parse_item(response) do
    {:ok, document} = response.body |> Floki.parse_document()

    case article_type(document) do
      :list ->
        %Crawly.ParsedItem{
          :requests =>
            list_article_links(document, response.request_url) |> Enum.map(&request_from_url(&1)),
          :items => []
        }

      :vehicle ->
        %Crawly.ParsedItem{
          :requests => [],
          :items => to_wikipedia_vehicles(document, response.request_url)
        }

      _ ->
        %Crawly.ParsedItem{:requests => [], :items => []}
    end
  end

  def orbital_launch_article?(html) do
    not Enum.empty?(html |> Floki.find("#Orbital_launch_systems"))
  end

  def orbital_launch_list_article?(html) do
    html |> Floki.find("h1") |> Floki.text() === "List of orbital launch systems"
  end

  def orbital_launch_vehicle_article?(html) do
    not Enum.empty?(
      html
      |> Floki.find(".mw-parser-output > table.infobox.hproduct > caption.infobox-title")
    )
  end

  def article_type(html) do
    case {
      orbital_launch_article?(html),
      orbital_launch_vehicle_article?(html),
      orbital_launch_list_article?(html)
    } do
      {true, true, _} -> :vehicle
      {true, _, true} -> :list
      {_, _, _} -> nil
    end
  end

  def partial_key(partial_key) do
    fn :get, data, next ->
      if is_map(data) do
        Enum.find_value(data, fn {key, value} ->
          if String.contains?(key, partial_key), do: value
        end)
        |> next.()
      else
        next.(data)
      end
    end
  end

  @spec to_wikipedia_vehicles(Floki.html_tree() | Floki.html_node(), String.t()) ::
          list(%WikipediaVehicle{})
  @doc """
  Parse a wikipedia page and extract all the launch vehicle info tables as Rocketsized.Datasource.WikipediaVehicle objects

  Returns `[%WikipediaVehicle{}]`.

  ## Examples

      iex> html |> to_wikipedia_vehicle("https://en.wikipedia.org/wiki/Ceres-1")
      [%WikipediaVehicle{}]
  """
  def to_wikipedia_vehicles(html, url) do
    info_boxes = html |> Floki.find(".mw-parser-output > table")

    info_boxes
    |> Enum.flat_map(fn table_html ->
      data = read_info_box(table_html)
      statuses = get_in(data, ["Launch history", "Status"])

      cond do
        is_map(statuses) ->
          for {name, status} <- statuses do
            %WikipediaVehicle{
              title: "#{get_in(data, ["Main", "Title"])} #{name}",
              manufacturers: infer_manufacturers(get_in(data, ["Main", "Manufacturer"])),
              country: infer_country(get_in(data, ["Main", "Country of origin"])),
              status: infer_status(status),
              stages:
                infer_stages(
                  get_in(data, ["Main", "Stages", partial_key(name)]) ||
                    get_in(data, ["Main", "Stages"]) ||
                    get_in(data, ["Size", "Stages"])
                ),
              height:
                infer_height(
                  get_in(data, ["Size", "Height", partial_key(name)]) ||
                    get_in(data, ["Size", "Height"])
                ),
              source: url
            }
          end

        is_bitstring(statuses) ->
          [
            %WikipediaVehicle{
              title: get_in(data, ["Main", "Title"]),
              manufacturers: infer_manufacturers(get_in(data, ["Main", "Manufacturer"])),
              country: infer_country(get_in(data, ["Main", "Country of origin"])),
              status: infer_status(statuses),
              stages:
                infer_stages(
                  get_in(data, ["Main", "Stages"]) ||
                    get_in(data, ["Size", "Stages"])
                ),
              height: infer_height(get_in(data, ["Size", "Height"])),
              source: url
            }
          ]

        true ->
          []
      end
    end)
  end

  @spec read_info_box(Floki.html_tree() | Floki.html_node()) :: map()
  @doc """
  Parse a wikipedia infobox table into a nested map of all the info
  Support
   - titled lists inside the data cells
   - lists of links
   - group captions

  Returns `%{"Main" => %{"Title" => "something"}}`.

  ## Examples

      iex> html |> Floki.find(".mw-parser-output > table") |> read_info_box()
      %{"Main" => %{"Title" => "something"}}
  """
  def read_info_box(table) do
    title = table |> Floki.find(":root > caption.infobox-title") |> Floki.text(deep: false)

    table
    |> Floki.find(":root > tbody > tr")
    |> Enum.reduce(%{current: "Main", data: %{"Main" => %{"Title" => title}}}, fn row, acc ->
      section = row |> Floki.find(":root > th[colspan=\"2\"]") |> Floki.text(deep: false)

      case section do
        "" ->
          title = row |> Floki.find(":root > th[scope=\"row\"]") |> Floki.text()
          content = row |> Floki.find(":root > td.infobox-data")
          content_list = content |> Floki.find("ul > li")
          content_anchors = content |> Floki.find("a[title]")

          text =
            cond do
              length(content_anchors) > 1 ->
                for item <- content_anchors, do: item |> Floki.text(deep: false)

              length(content_anchors) == 1 ->
                content_anchors |> Floki.text()

              length(content_list) > 1 ->
                for item <- content_list, into: %{} do
                  {item |> Floki.find("b") |> Floki.text() |> String.trim(":") |> String.trim(),
                   item |> Floki.text(deep: false) |> String.trim(":") |> String.trim()}
                end

              length(content_list) == 1 ->
                content_list |> Floki.text()

              true ->
                content |> Floki.text(deep: false)
            end

          case title do
            "" -> acc
            _ -> put_in(acc, [:data, acc.current, title], text)
          end

        _ ->
          %{current: section, data: Map.put(acc.data, section, %{})}
      end
    end)
    |> get_in([:data])
  end

  def list_article_links(html, base_url) do
    html
    |> Floki.find(".mw-parser-output > ul a[title]")
    |> Floki.attribute("href")
    |> Enum.map(&URI.merge(base_url, &1))
    |> Enum.map(&to_string(&1))
  end

  def infer_status(status) do
    cond do
      String.match?(status, ~r/(Planned)/iu) ->
        :planned

      String.match?(status, ~r/(Active|Operational)/iu) ->
        :operational

      String.match?(status, ~r/(Retired|Production\sended)/iu) ->
        :retired

      String.match?(status, ~r/(Canceled)/iu) ->
        :canceled

      String.match?(status, ~r/(In\sdevelopment|In\sconstruction|Under\sdevelopment)/iu) ->
        :in_development

      true ->
        nil
    end
  end

  def infer_country(countries) do
    if is_list(countries), do: List.first(countries), else: countries
  end

  def infer_manufacturers(manufacturers) do
    if is_list(manufacturers) do
      manufacturers |> Enum.filter(&(not String.match?(&1, ~r/(S-IC|S-II|S-IVB|H-IIA)/iu)))
    else
      [manufacturers]
    end
  end

  @spec infer_stages(any()) :: binary() | list() | map()
  def infer_stages(status) do
    cond do
      is_map(status) ->
        nil

      is_nil(status) ->
        nil

      String.match?(status, ~r/( or | to |\/)/iu) ->
        Regex.split(~r/ or | to |\//iu, status) |> Enum.map(&infer_stages(&1))

      String.match?(status, ~r/One/iu) ->
        "1"

      String.match?(status, ~r/Two/iu) ->
        "2"

      String.match?(status, ~r/Three/iu) ->
        "3"

      String.match?(status, ~r/Four/iu) ->
        "4"

      String.match?(status, ~r/Five/iu) ->
        "4"

      true ->
        status
    end
  end

  def infer_height(height) do
    cond do
      is_map(height) ->
        nil

      height ->
        Regex.run(~r/([\d\,\.]+)\s?m/u, height)
        |> Enum.at(1)
        |> Float.parse()
        |> case do
          {value, _} -> value
          :error -> nil
        end

      true ->
        nil
    end
  end
end
