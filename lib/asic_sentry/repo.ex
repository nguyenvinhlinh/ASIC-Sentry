defmodule AsicSentry.Repo do
  use Ecto.Repo,
    otp_app: :asic_sentry,
    adapter: Ecto.Adapters.Postgres
end
