# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :bookstore,
  ecto_repos: [Bookstore.Repo]

# Configures the endpoint
config :bookstore, BookstoreWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aElYkxWPesGVsBY+ZnBPqGGnFr+DQkjJQEwy2l4DyO1PflIEdC7w+m958p6pP8xE",
  render_errors: [view: BookstoreWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Bookstore.Graphql.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
