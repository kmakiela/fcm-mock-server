defmodule FcmMock.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      FcmMockWeb.Endpoint,
      # Starts a worker by calling: FcmMock.Worker.start_link(arg)
      # {FcmMock.Worker, arg},

      # ErrorConfig State contains setups of error configurations for device tokens
      FcmMock.Mock.ErrorConfig.State,
      # Activity State contains activity logs
      FcmMock.Mock.Activity.State
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FcmMock.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    FcmMockWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
