defmodule Bookstore.Graphql.BookResolver do
  @moduledoc false

  import Ecto.Query
  import Bookstore.Graphql.ParamsHelper

  alias Bookstore.Repo
  alias Bookstore.Schema.Book

  def book_get(_parent, %{id: id}, _resolution) do
    case Repo.get_by(Book, id: id) do
      %Book{} = book ->
        {:ok, book}
      _ ->
        {:error, "Book not found"}
    end
  end

  def book_get(_parent, _args, _resolution) do
    {:error, "Invalid parameters"}
  end

  def book_list(_parent, args, _resolution) do
    {offset, limit} = offset_limit(args)

    books =
      Book
      |> offset([_], ^offset)
      |> limit([_], ^limit)
      |> Repo.all()

    {:ok, books}
  end

end