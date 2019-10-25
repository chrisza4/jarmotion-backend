# Jarmotion

Jarmotion is a little application I built for my wedding.

This application use Phoenix server and Elixir.

To start your Server server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Install Node.js dependencies with `cd assets && npm install`
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Deployments

We use edeliver to deliver upgrade and release to server

### Prerequiste

- You need to setup SSH key to server that deploy jarmotion with user name root

### Clean release

- `mix edeliver stop production`
- SSH to server and remove folder app_build and folder app_release
- Run `./deployments/release_new.sh`

### Upgrade release

edeliver use Erlang hot code push to redeploy without downtime

- Check current version from production at `mix edeliver version production`
- Run `./deployments/release_upgrade.sh ${Version}`

This will build **upgrade package** for hot code reload and push to production

## Learn more Phoenix

- Official website: http://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Mailing list: http://groups.google.com/group/phoenix-talk
- Source: https://github.com/phoenixframework/phoenix
