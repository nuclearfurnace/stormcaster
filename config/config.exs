# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :stormcaster,
  ecto_repos: [Stormcaster.Repo]

# Configures the endpoint
config :stormcaster, StormcasterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "IjTEdvFmBGKAy6tAZSiRNY5mmDpH3hHQmF0iJVuMzmL/LfAnCE8glYK1jCaAA2SJ",
  render_errors: [view: StormcasterWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Stormcaster.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
