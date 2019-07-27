use Mix.Config

# Configure your database
config :jarmotion, Jarmotion.Repo,
  username: "postgres",
  password: "postgres",
  database: "jarmotion_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :jarmotion, JarmotionWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :jarmotion, Jarmotion.Guardian,
  issuer: "jarmotion",
  secret_key: "tXO9b8AH0pfmKgO/k39aeOnSevlHvR3t4NPkfCGcr/o+3CIzv2FD8vxWP3+eIjdW"
