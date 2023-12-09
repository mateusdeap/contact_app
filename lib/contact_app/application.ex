defmodule ContactApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ContactAppWeb.Telemetry,
      ContactApp.Repo,
      {DNSCluster, query: Application.get_env(:contact_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ContactApp.PubSub},
      # Start a worker by calling: ContactApp.Worker.start_link(arg)
      # {ContactApp.Worker, arg},
      # Start to serve requests, typically the last entry
      ContactAppWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ContactApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ContactAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
