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

config :jarmotion, JarmotionWeb.Endpoint,
  https: [
    :inet6,
    port: 443,
    cipher_suite: :strong,
    keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
    certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
  ],
  # This is critical for ensuring web-sockets properly authorize.
  url: [host: "api.jarmotion.co", port: 443],
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  root: "."

config :jarmotion, Jarmotion.Guardian,
  issuer: "jarmotion",
  secret_key: System.get_env("JWT_SECRET")

config :arc,
  storage: Arc.Storage.S3,
  bucket: System.get_env("JARMOTION_BUCKET")

config :ex_aws, :s3, %{
  access_key_id: System.get_env("AWS_ACCESS_KEY"),
  secret_access_key: System.get_env("AWS_SECRET"),
  scheme: "https://",
  host: "jarmotion.sgp1.digitaloceanspaces.com",
  region: "nyc3"
}

# ==================== For testing release locally =======================
# config :jarmotion, JarmotionWeb.Endpoint,
#   http: [
#     :inet6,
#     port: 80
#   ],
#   # This is critical for ensuring web-sockets properly authorize.
#   url: [host: "localhost", port: 80],
#   cache_static_manifest: "priv/static/cache_manifest.json",
#   server: true,
#   root: "."
