defmodule Bookstore.Graphql.BookResolver do
  @moduledoc false

  import Ecto.Query
  import Bookstore.Graphql.ParamsHelper

  alias Ecto.Changeset
  alias Bookstore.Repo
  alias Bookstore.Schema.Book
  alias Bookstore.Graphql.Pubsub

  def book_get(_parent, %{id: id}, _resolution) do
    book_get(id)
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

  def book_liked(_parent, %{id: id}, _resolution) do
    with {:ok, book} <- book_get(id),
        {:ok, book} <- book_like_inc(book) do
      Pubsub.book_updated(book)
      {:ok, book}
    else
      error ->
        error
    end
  end

  defp book_get(id) do
    case Repo.get_by(Book, id: id) do
      %Book{} = book ->
        {:ok, book}
      _ ->
        {:error, "Book not found"}
    end
  end

  defp book_like_inc(%{likes: nil} = book) do
    book_like_inc(%{book | likes: 0})
  end

  defp book_like_inc(book) do
    changeset = Changeset.change(book, %{likes: book.likes + 1})
    case Repo.update(changeset) do
       {:ok, book} ->
        {:ok, book}
      _ ->
        {:error, "Book update failed"}
    end
  end
end