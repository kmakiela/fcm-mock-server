# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :fcm_mock, FcmMockWeb.Endpoint,
  url: [host: "localhost", port: 4000],
  server: true,
  root: ".",
  version: Application.spec(:fcm_mock, :vsn),
  http: [port: 4001],
  https: [
    :inet6,
    port: 4000,
    cipher_suite: :compatible,
    keyfile: "priv/ssl/fake_key.pem",
    certfile: "priv/ssl/fake_cert.pem"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
