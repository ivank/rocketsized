defmodule Rocketsized.Repo.Migrations.StateFilters do
  use Ecto.Migration

  def change do
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

        UNION

        SELECT
          'state' AS "type",
          slug,
          short_name AS "title",
          name AS "subtitle",
          logo AS "image",
          ''::varchar(255) as "source"
        FROM
          (VALUES
            (
              'planned'::varchar(255),
              'Planned'::varchar(255),
              'Planned'::varchar(255),
              '/images/state/planned.svg'::varchar
            ),
            (
              'in_development'::varchar(255),
              'Developed'::varchar(255),
              'In Development'::varchar(255),
              '/images/state/in_development.svg'::varchar
            ),
            (
              'operational'::varchar(255),
              'Operational'::varchar(255),
              'Available to launch'::varchar(255),
              '/images/state/operational.svg'::varchar
            ),
            (
              'retired'::varchar(255),
              'Retired'::varchar(255),
              'No longer produced'::varchar(255),
              '/images/state/retired.svg'::varchar
            ),
            (
              'canceled'::varchar(255),
              'Canceled'::varchar(255),
              'Development stopped'::varchar(255),
              '/images/state/canceled.svg'::varchar
            )
          ) AS states (slug, short_name, name, logo)
      """,
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
      """
    )
  end
end
