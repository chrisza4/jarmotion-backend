# In this file, we load production configuration and
# secrets from environment variables. You can also
# hardcode secrets, although such is generally not
# recommended and you have to remember to add this
# file to your .gitignore.
use Mix.Config

# database_url =

config :jarmotion, Jarmotion.Repo,
  ssl: true,
  url: {:system, "DATABASE_URL"},
  pool_size: {:system, "POOL_SIZE", default: 10, type: :integer}

secret_key_base = {:system, "SECRET_KEY_BASE"}
