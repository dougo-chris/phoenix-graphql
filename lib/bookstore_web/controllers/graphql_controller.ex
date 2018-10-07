defmodule BookstoreWeb.GraphqlController do
  @moduledoc false

  use BookstoreWeb, :controller

  plug Absinthe.Plug, schema: Bookstore.Graphql.Query

  def query(conn, _params) do
    conn
  end
end