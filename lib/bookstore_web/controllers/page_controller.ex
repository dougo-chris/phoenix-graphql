defmodule BookstoreWeb.PageController do
  use BookstoreWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
