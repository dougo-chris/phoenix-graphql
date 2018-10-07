defmodule Bookstore.Graphql.Query.BooksTest do
  use BookstoreWeb.ConnCase, async: true

  @books """
    query GetBooks(
      $offset: ID!,
      $limit: ID!
    ) {
      books(offset: $offset, limit: $limit) {
        title
      }
    }
  """

  @book """
    query GetBook(
      $id: ID!
    ) {
      book(id: $id) {
        title
      }
    }
  """

  setup %{conn: conn} do
    author = Bookstore.Repo.insert!(%Bookstore.Schema.Author{name: Faker.Name.name(), email: Faker.Internet.email()})
    book_1 = Bookstore.Repo.insert!(%Bookstore.Schema.Book{author_id: author.id, title: "Book 1", pages: 1})
    book_2 = Bookstore.Repo.insert!(%Bookstore.Schema.Book{author_id: author.id, title: "Book 2", pages: 2})

    {:ok, %{conn: conn, book_1: book_1, book_2: book_2}}
  end

  test "get the books at offset 0", %{conn: conn} do
    conn =
      conn
      |> post("/graphql", %{
        query: @books,
        variables: %{offset: 0, limit: 1}
      })

    assert json_response(conn, 200) == %{
             "data" => %{
               "books" => [%{
                 "title" => "Book 1"
               }]
             }
           }
  end

  test "get the books at offset 1", %{conn: conn} do
    conn =
      conn
      |> post("/graphql", %{
        query: @books,
        variables: %{offset: 1, limit: 1}
      })

    assert json_response(conn, 200) == %{
             "data" => %{
               "books" => [%{
                 "title" => "Book 2"
               }]
             }
           }
  end

  test "get the book", %{conn: conn, book_1: book_1} do
    conn =
      conn
      |> post("/graphql", %{
        query: @book,
        variables: %{id: book_1.id}
      })

    assert json_response(conn, 200) == %{
             "data" => %{
               "book" => %{
                 "title" => "Book 1"
               }
             }
           }
  end
end