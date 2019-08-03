# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :jarmotion,
  ecto_repos: [Jarmotion.Repo],
  timezone: "Asia/Bangkok"

config :jarmotion, Jarmotion.Repo, migration_primary_key: [name: :uuid, type: :binary_id]

# Configures the endpoint
config :jarmotion, JarmotionWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "fLCco3ZEi0ycTmmiRlq+fq+4acqrOXiFkF9hnnA3Pub/J+sPkgWneOxJB/2Qu9cB",
  render_errors: [view: JarmotionWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Jarmotion.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase
