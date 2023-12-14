defmodule Rocketsized.DatasourceTest do
  use ExUnit.Case
  require Logger
  alias Rocketsized.Datasource.Wikipedia

  @pages [
           gslv: "Geosynchronous Satellite Launch Vehicle - Wikipedia.html",
           atlas3: "Atlas III - Wikipedia.html",
           antares: "Antares (rocket) - Wikipedia.html",
           atlas_able: "Atlas-Able - Wikipedia.html",
           rockets_list: "List of orbital launch systems - Wikipedia.html",
           family: "Long March (rocket family) - Wikipedia.html",
           ariane6: "Ariane 6 - Wikipedia.html",
           long_march_family: "Long March (rocket family) - Wikipedia.html",
           long_march_1d: "Long March 1D - Wikipedia.html",
           mv: "M-V - Wikipedia.html",
           shavit2: "Shavit 2 - Wikipedia.html",
           electron: "Rocket Lab Electron - Wikipedia.html",
           tronador: "Tronador (rocket) - Wikipedia.html",
           vega: "Vega (rocket) - Wikipedia.html",
           vls1: "VLS-1 - Wikipedia.html",
           titan23g: "Titan 23G - Wikipedia.html",
           delta3: "Delta III - Wikipedia.html",
           space_shuttle: "Space Shuttle - Wikipedia.html",
           saturn5: "Saturn V - Wikipedia.html",
           vostokK: "Vostok-K - Wikipedia.html"
         ]
         |> Enum.map(fn {title, file} ->
           {title, Path.join([__DIR__, "../support/fixtures/websites", file])}
         end)

  describe "wikipedia crawler" do
    test "partial_key finder test" do
      data = %{
        "Size" => %{
          "Diameter" => "3.9 m (13 ft)",
          "Height" => %{
            "110/120" => "40.5 m (133 ft)",
            "130" => "41.9 m (137 ft)",
            "230/230+" => "42.5 m (139 ft)"
          },
          "Mass" => %{
            "110/120/130" => "282,000-296,000 kg (622,000-653,000 lb)",
            "230/230+" => "298,000 kg (657,000 lb)"
          },
          "Stages" => "2 to 3"
        }
      }

      assert get_in(data, ["Size", "Height", Wikipedia.partial_key("110")]) ==
               "40.5 m (133 ft)"

      assert get_in(data, ["Size", "Height", Wikipedia.partial_key("130")]) ==
               "41.9 m (137 ft)"

      assert get_in(data, ["Size", "Height", Wikipedia.partial_key("230+")]) ==
               "42.5 m (139 ft)"
    end

    test "article type" do
      assert @pages[:gslv]
             |> File.read!()
             |> Floki.parse_document!()
             |> Wikipedia.article_type() ==
               :vehicle

      assert @pages[:rockets_list]
             |> File.read!()
             |> Floki.parse_document!()
             |> Wikipedia.article_type() ==
               :list

      assert @pages[:family]
             |> File.read!()
             |> Floki.parse_document!()
             |> Wikipedia.article_type() == nil
    end

    test "vehicle datasource gslv" do
      data =
        @pages[:gslv]
        |> File.read!()
        |> Floki.parse_document!()
        |> Wikipedia.to_wikipedia_vehicle("source1")

      expected = [
        %Rocketsized.Datasource.WikipediaVehicle{
          title: "GSLV Mk I",
          manufacturers: ["ISRO"],
          country: "India",
          status: :retired,
          stages: "3",
          height: 49.13,
          source: "source1"
        },
        %Rocketsized.Datasource.WikipediaVehicle{
          title: "GSLV Mk II",
          manufacturers: ["ISRO"],
          country: "India",
          status: :operational,
          stages: "3",
          height: 49.13,
          source: "source1"
        }
      ]

      assert data == expected
    end

    test "vehicle datasource ariane 6" do
      data =
        @pages[:ariane6]
        |> File.read!()
        |> Floki.parse_document!()
        |> Wikipedia.to_wikipedia_vehicle("source1")

      expected = [
        %Rocketsized.Datasource.WikipediaVehicle{
          title: "Ariane 6",
          manufacturers: ["ArianeGroup"],
          country: "European Space Agency",
          status: :in_development,
          stages: "2",
          height: 63,
          source: "source1"
        }
      ]

      assert data == expected
    end

    test "vehicle datasource shavit 2" do
      data =
        @pages[:shavit2]
        |> File.read!()
        |> Floki.parse_document!()
        |> Wikipedia.to_wikipedia_vehicle("source1")

      expected = [
        %Rocketsized.Datasource.WikipediaVehicle{
          title: "Shavit 2",
          manufacturers: ["Israel Aerospace Industries"],
          country: "Israel",
          status: :operational,
          stages: "4",
          height: 26.4,
          source: "source1"
        }
      ]

      assert data == expected
    end

    test "vehicle datasource tronador 2" do
      data =
        @pages[:tronador]
        |> File.read!()
        |> Floki.parse_document!()
        |> Wikipedia.to_wikipedia_vehicle("source1")

      expected = [
        %Rocketsized.Datasource.WikipediaVehicle{
          title: "Tronador II",
          manufacturers: ["CONAE"],
          country: "Argentina",
          status: :in_development,
          stages: "2",
          height: 27.0,
          source: "source1"
        }
      ]

      assert data == expected
    end

    test "vehicle datasource titan 23 G" do
      data =
        @pages[:titan23g]
        |> File.read!()
        |> Floki.parse_document!()
        |> Wikipedia.to_wikipedia_vehicle("source1")

      expected = [
        %Rocketsized.Datasource.WikipediaVehicle{
          title: "Titan 23G",
          manufacturers: ["Martin Marietta", "Lockheed Martin"],
          country: "United States",
          status: :retired,
          stages: ["2", "3"],
          height: 31.4,
          source: "source1"
        }
      ]

      assert data == expected
    end

    test "vehicle datasource delta III" do
      data =
        @pages[:delta3]
        |> File.read!()
        |> Floki.parse_document!()
        |> Wikipedia.to_wikipedia_vehicle("source1")

      expected = [
        %Rocketsized.Datasource.WikipediaVehicle{
          title: "Delta III",
          manufacturers: ["Boeing", "Mitsubishi Heavy Industries", "NASDA"],
          country: "United States",
          status: :retired,
          stages: "2",
          height: 35,
          source: "source1"
        }
      ]

      assert data == expected
    end

    test "vehicle datasource space shuttle" do
      data =
        @pages[:space_shuttle]
        |> File.read!()
        |> Floki.parse_document!()
        |> Wikipedia.to_wikipedia_vehicle("source1")

      expected = [
        %Rocketsized.Datasource.WikipediaVehicle{
          title: "Space Shuttle",
          manufacturers: [
            "United Space Alliance",
            "Thiokol",
            "Alliant Techsystems",
            "Lockheed Martin",
            "Martin Marietta",
            "Boeing",
            "Rockwell"
          ],
          country: "United States",
          status: :retired,
          stages: "1.5",
          height: 56.1,
          source: "source1"
        }
      ]

      assert data == expected
    end

    test "vehicle datasource saturn V" do
      data =
        @pages[:saturn5]
        |> File.read!()
        |> Floki.parse_document!()
        |> Wikipedia.to_wikipedia_vehicle("source1")

      expected = [
        %Rocketsized.Datasource.WikipediaVehicle{
          title: "Saturn V",
          manufacturers: ["Boeing", "North American", "Douglas"],
          country: "United States",
          status: :retired,
          stages: "3",
          height: 110.6,
          source: "source1"
        }
      ]

      assert data == expected
    end

    test "vehicle datasource atlas able" do
      data =
        @pages[:atlas_able]
        |> File.read!()
        |> Floki.parse_document!()
        |> Wikipedia.to_wikipedia_vehicle("source1")

      expected = [
        %Rocketsized.Datasource.WikipediaVehicle{
          title: "Atlas-Able",
          manufacturers: ["General Dynamics"],
          country: "United States",
          status: :retired,
          stages: nil,
          height: 28.0,
          source: "source1"
        }
      ]

      assert data == expected
    end

    test "vehicle datasource atlas 3" do
      data =
        @pages[:atlas3]
        |> File.read!()
        |> Floki.parse_document!()
        |> Wikipedia.to_wikipedia_vehicle("source1")

      expected = [
        %Rocketsized.Datasource.WikipediaVehicle{
          title: "Atlas III",
          manufacturers: ["Lockheed Martin"],
          country: "United States",
          status: :retired,
          stages: "2",
          height: 52.8,
          source: "source1"
        }
      ]

      assert data == expected
    end

    test "vehicle datasource vostok K" do
      data =
        @pages[:vostokK]
        |> File.read!()
        |> Floki.parse_document!()
        |> Wikipedia.to_wikipedia_vehicle("source1")

      expected = [
        %Rocketsized.Datasource.WikipediaVehicle{
          title: "Vostok-K",
          manufacturers: ["OKB-1"],
          country: "USSR",
          status: :retired,
          stages: "2",
          height: 30.84,
          source: "source1"
        }
      ]

      assert data == expected
    end

    test "vehicle datasource antares" do
      data =
        @pages[:antares]
        |> File.read!()
        |> Floki.parse_document!()
        |> Wikipedia.to_wikipedia_vehicle("source1")

      expected = [
        %Rocketsized.Datasource.WikipediaVehicle{
          country: "United States",
          height: 40.5,
          manufacturers: ["Northrop Grumman", "Pivdenmash", "NPO Energomash"],
          source: "source1",
          stages: ["2", "3"],
          status: :retired,
          title: "Antares 110"
        },
        %Rocketsized.Datasource.WikipediaVehicle{
          title: "Antares 120",
          manufacturers: ["Northrop Grumman", "Pivdenmash", "NPO Energomash"],
          country: "United States",
          status: :retired,
          stages: ["2", "3"],
          height: 40.5,
          source: "source1"
        },
        %Rocketsized.Datasource.WikipediaVehicle{
          title: "Antares 130",
          manufacturers: ["Northrop Grumman", "Pivdenmash", "NPO Energomash"],
          country: "United States",
          status: :retired,
          stages: ["2", "3"],
          height: 41.9,
          source: "source1"
        },
        %Rocketsized.Datasource.WikipediaVehicle{
          title: "Antares 230",
          manufacturers: ["Northrop Grumman", "Pivdenmash", "NPO Energomash"],
          country: "United States",
          status: :retired,
          stages: ["2", "3"],
          height: 42.5,
          source: "source1"
        },
        %Rocketsized.Datasource.WikipediaVehicle{
          title: "Antares 230+",
          manufacturers: ["Northrop Grumman", "Pivdenmash", "NPO Energomash"],
          country: "United States",
          status: :retired,
          stages: ["2", "3"],
          height: 42.5,
          source: "source1"
        },
        %Rocketsized.Datasource.WikipediaVehicle{
          title: "Antares 300",
          manufacturers: ["Northrop Grumman", "Pivdenmash", "NPO Energomash"],
          country: "United States",
          status: :planned,
          stages: ["2", "3"],
          height: nil,
          source: "source1"
        }
      ]

      assert data == expected
    end
  end
end
