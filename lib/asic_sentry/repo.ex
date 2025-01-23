defmodule AsicSentry.Repo do
  use Ecto.Repo,
    otp_app: :asic_sentry,
    adapter: Ecto.Adapters.SQLite3
end
