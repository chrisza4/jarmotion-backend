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

    get "/avatar/:id", UserController, :get_avatar
    get "/avatar/thumb/:id", UserController, :get_thumb_avatar
  end

  # Other scopes may use custom stacks.
  scope "/api", JarmotionWeb do
    pipe_through :api
    post "/login", AuthController, :login
    post "/register", UserController, :post_register

    pipe_through :jwt_authenticated

    scope "/emoji" do
      get "/user/:id", EmojiController, :list
      get "/user", EmojiController, :list_owner
      get "/stats", EmojiController, :stats
      get "/:id", EmojiController, :get
      post "/", EmojiController, :post
    end

    scope "/alert" do
      get "/:id", AlertController, :get
      post "/", AlertController, :post
      post "/:id/ack", AlertController, :post_ack
      get "/", AlertController, :list_recent
    end

    scope "/users" do
      get "/relationship", UserController, :lover
      post "/relationship", UserController, :post_lover
      get "/me", UserController, :me
      post "/me", UserController, :post_me
      post "/avatar", UserController, :post_avatar
    end

    scope "/devices" do
      post "/", DeviceController, :post
      delete "/:token", DeviceController, :delete
    end

    scope "/sensors" do
      post "/", SensorController, :post
      get "/", SensorController, :list
      delete "/", SensorController, :delete
    end
  end
end
