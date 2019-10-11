mix deps.get --only prod
mix compile
mix ecto.migrate
yes Y | mix release
echo "Stop server"
_build/prod/rel/jarmotion/bin/jarmotion stop
echo "Start server"
_build/prod/rel/jarmotion/bin/jarmotion daemon
