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
