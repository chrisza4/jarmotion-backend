# In this file, we load production configuration and
# secrets from environment variables. You can also
# hardcode secrets, although such is generally not
# recommended and you have to remember to add this
# file to your .gitignore.
use Mix.Config

config :jarmotion, Jarmotion.Repo,
  ssl: true,
  url: System.get_env("DATABASE_URL"),
  pool_size: 10
