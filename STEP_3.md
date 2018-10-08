## Complex queries

#### Create the author and review types and resolvers

This is the same as creating the book types and resolvers in STEP_2

#### Create a helper for offset and limit params

Edit `lib/graphql/helpers/params_helper.ex`

```
defmodule Bookstore.Graphql.ParamsHelper do
  @moduledoc false

  @limit_default 10

  def offset_limit(%{offset: offset, limit: limit}), do: {offset, limit}
  def offset_limit(%{offset: offset}), do: {offset, @limit_default}
  def offset_limit(%{limit: limit}), do: {0, limit}
  def offset_limit(_), do: {0, @limit_default}

end
```

#### Add dataloader to the Bookstore.Graphql.Query

Edit `lib/graphql/query.ex`

```
  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

```

#### Add dataloader to the BookstoreWeb.GraphqlController

Edit `lib/bookstore_web/controllers/graphql_controller.ex`

```
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
```

#### Add the relationships to Bookstore.Graphql.BookType

Edit `lib/graphql/types/book_type.ex`

```
defmodule Bookstore.Graphql.BookType do
  @moduledoc false

  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers

  @desc "books"
  object :book do
    field :id, :id
    field :author_id, :integer
    field :title, :string
    field :pages, :integer

    field :author, :author, resolve: dataloader(:item_loader, :author)

    field :reviews, list_of(:review) do
      arg :offset, :integer
      arg :limit, :integer
      resolve dataloader(:list_loader, :reviews)
    end
  end
end
```

#### Run the query

Run `mix phx.server`

Open `localhost:4000/graphiql`

Complex Query
```
query{
  books {
    id,
    title,
    author {
      name
    },
    reviews(limit: 6) {
      comment,
      author {
        name
        reviews(limit: 3) {
          book {
            title
          }
        }
      }
    }
  }
}

```

