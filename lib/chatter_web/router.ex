defmodule ChatterWeb.Router do
  use ChatterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.EnsureAuthenticated, handler: Chatter.Token
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChatterWeb do
    pipe_through :browser
    resources "/sessions", SessionController, only: [:create, :delete]
    resources "/users", UserController, [:new, :create]
    get "/", SessionController, :new
  end

  scope "/", ChatterWeb do
    pipe_through [:browser, :browser_auth] # Use the default browser stack
    resources "/users", UserController, only: [:show, :index, :update]
    get "/chat", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChatterWeb do
  #   pipe_through :api
  # end
end
