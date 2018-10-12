## Simple query

#### Create the book type

Edit `lib/graphql/types/book_type.ex`

```
defmodule Bookstore.Graphql.BookType do
  @moduledoc false

  use Absinthe.Schema.Notation

  @desc "books"
  object :book do
    field :id, :id
    field :author_id, :integer
    field :title, :string
    field :pages, :integer
  end
end
```

#### Create the graphql query

Edit `lib/graphql/query.ex`

```
defmodule Bookstore.Graphql.Query do
  @moduledoc false

  use Absinthe.Schema

  alias Bookstore.Graphql.BookResolver

  import_types Bookstore.Graphql.BookType

  def plugins do
    Absinthe.Plugin.defaults()
  end

  query do
    field :book, :book do
      arg :id, :id
      resolve &BookResolver.book_get/3
    end

    field :books, list_of(:book) do
      arg :offset, :integer
      arg :limit, :integer
      resolve &BookResolver.book_list/3
    end
  end
end
```

#### Create the book resolver

Edit `lib/graphql/types/book_resolver.ex`

```
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
    {offset, limit} = offset_limit(args)

    books =
      Book
      |> offset([_], ^offset)
      |> limit([_], ^limit)
      |> Repo.all()

    {:ok, books}
  end

  defp offset_limit(%{offset: offset, limit: limit}), do: {offset, limit}
  defp offset_limit(%{offset: offset}), do: {offset, @limit_default}
  defp offset_limit(%{limit: limit}), do: {0, limit}
  defp offset_limit(_), do: {0, @limit_default}

end
```

#### Add the graphql endpoint to the router

Edit `lib/bookstore_web/router.ex`

```
  ...

  scope "/" do
    pipe_through :api

    get "/graphql", BookstoreWeb.GraphqlController, :query
    post "/graphql", BookstoreWeb.GraphqlController, :query

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: Bookstore.Graphql.Query
  end

  ...

```

#### Create the GraphqlController

Edit `lib/bookstore_web/controllers/graphql_controlller.ex`

```
defmodule BookstoreWeb.GraphqlController do
  @moduledoc false

  use BookstoreWeb, :controller

  plug Absinthe.Plug, schema: Bookstore.Graphql.Query

  def query(conn, _params) do
    conn
  end
end
```

#### Run the query

Run `mix phx.server`

Open `localhost:4000/graphiql`

List books
```
query{
  books {
    id,
    title
  }
}
```

List with filter
```
query{
  books(offset: 10, limit:100) {
    id,
    title
  }
}
```

Show a book
```
query{
  book(id: 32) {
    id,
    title
  }
}
```

#### Add tests

Edit `test/graphql/queries/book_test.exs`

```
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
```
