defmodule Rocketsized.Repo.Migrations.SearchView do
  use Ecto.Migration

  def change do
    alter table(:countries) do
      add :short_name, :string
    end

    execute("UPDATE countries SET short_name = name", "")

    create index(:vehicles, [:is_published])

    create index(
             :vehicles,
             ["name text_pattern_ops", "alternative_name text_pattern_ops"],
             name: "vehicles_search_idx"
           )

    create index(
             :countries,
             ["name text_pattern_ops", "short_name text_pattern_ops"],
             name: "countries_search_idx"
           )

    create index(
             :manufacturers,
             ["name text_pattern_ops", "short_name text_pattern_ops"],
             name: "manufacturers_search_idx"
           )

    execute(
      """
      CREATE VIEW vehicle_filters AS
        SELECT
          'vehicle' AS "type",
          id,
          name AS "title",
          alternative_name AS "subtitle",
          image AS "image",
          source
        FROM
          vehicles
        WHERE
          is_published = true

        UNION

        SELECT
          'country' AS "type",
          id,
          short_name AS "title",
          name AS "subtitle",
          flag AS "image",
          source
        FROM
          countries

        UNION

        SELECT
          'manufacturer' AS "type",
          id,
          short_name AS "title",
          name AS "subtitle",
          logo AS "image",
          source
        FROM
          manufacturers
      """,
      "DROP VIEW vehicle_filters"
    )
  end
end
