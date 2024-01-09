defmodule Rocketsized.Repo.Migrations.NewFilters do
  use Ecto.Migration

  def change do
    create unique_index(:countries, [:code])

    execute(
      """
      CREATE OR REPLACE VIEW search_slugs AS
        SELECT
          'rocket' AS "type",
          slug,
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
          code AS "slug",
          short_name AS "title",
          name AS "subtitle",
          flag AS "image",
          source
        FROM
          countries

        UNION

        SELECT
          'org' AS "type",
          slug,
          short_name AS "title",
          name AS "subtitle",
          logo AS "image",
          source
        FROM
          manufacturers
      """,
      """
      DROP VIEW search_slugs
      """
    )

    execute(
      "DROP VIEW vehicle_filters",
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
      """
    )
  end
end
