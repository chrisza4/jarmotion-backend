defmodule JarmotionWeb.Router do
  use JarmotionWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug JarmotionWeb.Guardian.AuthPipeline
  end

  scope "/", JarmotionWeb do
    pipe_through :browser

    get "/", PageController, :index
    post "/login", AuthController, :login
  end

  # Other scopes may use custom stacks.
  scope "/api", JarmotionWeb do
    pipe_through [:api, :jwt_authenticated]

    scope "/emoji" do
      get "/:id", EmojiController, :list
    end
  end
end
