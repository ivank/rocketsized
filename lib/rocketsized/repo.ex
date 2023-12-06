defmodule Rocketsized.Repo do
  use Ecto.Repo,
    otp_app: :rocketsized,
    adapter: Ecto.Adapters.Postgres
end
