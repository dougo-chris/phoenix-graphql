## Subscriptions

#### Create the channel

Edit `lib/bookstore_web/channels/graphql_socket.ex`

```
defmodule BookstoreWeb.GraphqlSocket do
  @moduledoc false

  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: Bookstore.Graphql.Query

  transport :websocket, Phoenix.Transports.WebSocket

  def connect(_params, socket) do
    socket = Absinthe.Phoenix.Socket.put_options(socket, context: %{})

    {:ok, socket}
  end

  def id(_socket), do: nil
end
```

#### Add the subscription

Edit `lib/graphql/query.ex`

```
  subscription do
    field :book_updated, :book do
      arg :id, :id

      config(fn args, _context ->
        {:ok, topic: args.id}
      end)
    end
  end

```

#### Configure the pubsub config for the Endpoint

Edit `config/config.exs`

```
config :bookstore, BookstoreWeb.Endpoint,
  ...
  pubsub: [name: Bookstore.Graphql.PubSub, adapter: Phoenix.PubSub.PG2]

```

#### Setup the pubsub

Edit `lib/graphql/pubsub.ex`

```
defmodule Bookstore.Graphql.Pubsub do
  @moduledoc false

  def book_updated(book) do
    do_publish(book, book_updated: book.id)
  end

  defp do_publish(payload, topics) do
    Absinthe.Subscription.publish(BookstoreWeb.Endpoint, payload, topics)
  end

end
```

#### Set the socket endpoint

Edit `lib/bookstore_web/endpoint.ex`

```
  use Absinthe.Phoenix.Endpoint

  socket "/socket", BookstoreWeb.GraphqlSocket
```

#### Start the Absinthe.Subscription on startup

Edit `lib/bookstore/application.ex`

```
  ...

  def start(_type, _args) do
    ...

    children = [
      ...
      supervisor(Absinthe.Subscription, [BookstoreWeb.Endpoint])

    ...
```

#### Update GraphiQL to use the socket

Edit `lib/bookstore_web/router.ex`

```
  ...

  forward "/graphiql", Absinthe.Plug.GraphiQL,
    schema: Bookstore.Graphql.Query,
    socket: BookstoreWeb.GraphqlSocket
```

#### Test the subscription

Run phoenix under iex `iex -S mix "phx.server"`

Open `localhost:4000/graphiql`

Set the `WS URL` to `ws://localhost:4000/socket`

Subscribe to changes

```
subscription {
  bookUpdated(id: 10) {
    title
  }
}

```

In `iex` find the book and trigger an update

```
book = Bookstore.Repo.get_by(Bookstore.Schema.Book, id: 10)
Bookstore.Graphql.Pubsub.book_updated(book)
```
