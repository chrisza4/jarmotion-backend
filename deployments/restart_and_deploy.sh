mix deps.get --only prod
MIX_ENV=prod mix compile
MIX_ENV=prod mix ecto.migrate
MIX_ENV=prod mix phx.server

# MIX_ENV=prod elixir --erl "-detached" -S mix phx.server
