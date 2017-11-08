defmodule StormcasterWeb.Router do
  use StormcasterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", StormcasterWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/replays/:id", ReplayController, :show
  end

  scope "/api", StormcasterWeb do
     pipe_through :api

     post "/replays", ReplayController, :create
  end
end
