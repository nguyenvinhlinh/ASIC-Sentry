defmodule AsicSentry.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AsicSentryWeb.Telemetry,
      AsicSentry.Repo,
      {DNSCluster, query: Application.get_env(:asic_sentry, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AsicSentry.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: AsicSentry.Finch},
      # Start a worker by calling: AsicSentry.Worker.start_link(arg)
      # {AsicSentry.Worker, arg},
      # Start to serve requests, typically the last entry
      AsicSentryWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AsicSentry.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AsicSentryWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
