import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :asic_sentry, AsicSentry.Repo,
  pool: Ecto.Adapters.SQL.Sandbox

config :asic_sentry, AsicSentry.Repo,
  [database: "/home/nguyenvinhlinh/Projects/asic_sentry/data/test-data.db",
   journal_mode: :wal,
   cache_size: -64000,
   temp_store: :memory,
   pool_size: 5]

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :asic_sentry, AsicSentryWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "WUQPfTZ6a76dEs46XfOlHn+p1UfErzPYFF85HGIMvzDe3d/+zKSqUiO8ubKKYwEG",
  server: false

# In test we don't send emails
config :asic_sentry, AsicSentry.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
