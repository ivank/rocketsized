defmodule RocketsizedWeb.FilterParamsTest do
  use Rocketsized.DataCase

  alias RocketsizedWeb.FilterParams

  describe "FilterParams" do
    test "should load and dump params" do
      pairs = [
        {["c_ca"], [country: ["ca"]]},
        {["r_fh", "r_f9"], [rocket: ["fh", "f9"]]},
        {["o_spacex"], [org: ["spacex"]]},
        {["r_fh", "r_f9", "o_spacex"], [org: ["spacex"], rocket: ["fh", "f9"]]},
        {["c_ca", "o_spacex"], [country: ["ca"], org: ["spacex"]]},
        {["c_ca", "r_fh", "r_f9"], [country: ["ca"], rocket: ["fh", "f9"]]},
        {["c_ca", "r_fh", "r_f9", "o_spacex"],
         [country: ["ca"], org: ["spacex"], rocket: ["fh", "f9"]]}
      ]

      for {full, simple} <- pairs do
        dumped =
          FilterParams.dump_params(filters: [%Flop.Filter{field: :search, op: :in, value: full}])

        assert dumped == simple

        http_transmitted_data = simple |> Map.new() |> Jason.encode!() |> Jason.decode!()
        loaded = FilterParams.load_params(http_transmitted_data)
        assert loaded["filters"] == [%{"field" => "search", "op" => "in", "value" => full}]
      end
    end
  end
end
