## Mutations

#### Add the likes field to the books schema & graphql type

- Note : The original database migration has the `likes` column

Edit `lib/bookstore/schema/book.ex`

```
defmodule Bookstore.Schema.Book do
  ...

  field :likes, :integer

```

Edit `lib/graphql/types/book_type.ex`

```
defmodule Bookstore.Graphql.BookType do
  ...

  schema "books" do
    ...

    field :likes, :integer

```

#### Add the mutation to the query

Edit `lib/graphql/query`

```
defmodule Bookstore.Graphql.Query do
...

  mutation do
    field :book_liked, :book do
      arg :id, non_null(:integer)

      resolve &BookResolver.book_liked/3
    end
  end
```

#### Add book_like function to the resolver

This updates the database and publishes the update book to any subscription

Edit `lib/graphql/resolvers/book_resolver.ex`

```
defmodule Bookstore.Graphql.BookResolver do
  ...

  alias Ecto.Changeset
  alias Bookstore.Graphql.Pubsub
  ...

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
```


#### Test the mutation

mix phx.server

Open two browser windows with `localhost:4000/graphiql`

In one the `WS URL` to `ws://localhost:4000/socket`

Subscribe to changes

```
subscription {
  bookUpdated(id: 10) {
    title,
    likes
  }
}

```

In the other like the book

```
mutation {
  bookLiked(id:10) {
    title,
    likes
  }
}
```
