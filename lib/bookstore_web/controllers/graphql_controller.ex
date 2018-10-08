defmodule BookstoreWeb.GraphqlController do
  @moduledoc false

  use BookstoreWeb, :controller

  import Ecto.Query
  import Bookstore.Graphql.ParamsHelper

  alias Absinthe.Plug

  plug :absinthe_init
  plug Absinthe.Plug, schema: Bookstore.Graphql.Query

  def query(conn, _params) do
    conn
  end

  defp absinthe_init(conn, _) do
    Plug.put_options(conn, context: %{loader: build_loader(%{})})
  end

  defp build_loader(params) do
    Dataloader.new()
    |> Dataloader.add_source(:db, Dataloader.Ecto.new(Bookstore.Repo))
    |> Dataloader.add_source(:item_loader, dataloader_item(params))
    |> Dataloader.add_source(:list_loader, dataloader_list(params))
  end

  defp dataloader_item(params) do
    Dataloader.Ecto.new(Bookstore.Repo, query: &item_query/2, default_params: params)
  end

  defp dataloader_list(params) do
    Dataloader.Ecto.new(Bookstore.Repo, query: &list_query/2, default_params: params)
  end

  defp item_query(model, _params) do
    model
  end

  defp list_query(model, params) do
    {offset, limit} = offset_limit(params)

    model
    |> offset([_], ^offset)
    |> limit([_], ^limit)
  end

end