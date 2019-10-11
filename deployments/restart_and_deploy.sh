mix deps.get --only prod
mix compile
mix ecto.migrate
mix release
_build/prod/rel/jarmotion/bin/jarmotion stop
_build/prod/rel/jarmotion/bin/jarmotion daemon

# MIX_ENV=prod elixir --erl "-detached" -S mix phx.server
