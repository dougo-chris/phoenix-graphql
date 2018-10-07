defmodule BookstoreWeb.Router do
  use BookstoreWeb, :router

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

  scope "/", BookstoreWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/" do
    pipe_through :api

    get "/graphql", BookstoreWeb.GraphqlController, :query
    post "/graphql", BookstoreWeb.GraphqlController, :query

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: Bookstore.Graphql.Query
  end
end
