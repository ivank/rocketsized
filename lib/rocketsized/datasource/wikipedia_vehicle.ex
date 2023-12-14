defmodule Rocketsized.Datasource.WikipediaVehicle do
  defstruct title: nil,
            manufacturers: nil,
            country: nil,
            status: nil,
            stages: nil,
            height: nil,
            source: nil

  @type status() :: :in_development | :operational | :retired | :canceled

  @type t() :: %__MODULE__{
          :title => String.t(),
          :manufacturers => list(String.t()) | nil,
          :country => String.t() | nil,
          :status => status() | nil,
          :stages => String.t() | nil,
          :height => Integer.t() | nil,
          :source => String.t() | nil
        }
end
