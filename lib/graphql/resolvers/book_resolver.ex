defmodule Bookstore.Graphql.BookResolver do
  @moduledoc false
  import Ecto.Query

  alias Bookstore.Repo
  alias Bookstore.Schema.Book

  @limit_default 10

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
    {offset, limit} = limit(args)

    books =
      Book
      |> offset([_], ^offset)
      |> limit([_], ^limit)
      |> Repo.all()

    {:ok, books}
  end

  defp limit(%{offset: offset, limit: limit}), do: {offset, limit}
  defp limit(%{offset: offset}), do: {offset, @limit_default}
  defp limit(%{limit: limit}), do: {0, limit}
  defp limit(_), do: {0, @limit_default}

end