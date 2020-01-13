defmodule AlienDemoWeb.Router do
  use AlienDemoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AlienDemoWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/aliens", AliensController, :index
    get "/aliens/:name", AliensController, :is_alien
    resources "/saucers", SaucersController
  end

  # Other scopes may use custom stacks.
  # scope "/api", AlienDemoWeb do
  #   pipe_through :api
  # end
end
