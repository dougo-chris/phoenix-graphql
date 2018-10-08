defmodule Bookstore.Graphql.Pubsub do
  @moduledoc false

  def book_updated(book) do
    do_publish(book, book_updated: book.id)
  end

  defp do_publish(payload, topics) do
    Absinthe.Subscription.publish(BookstoreWeb.Endpoint, payload, topics)
  end

end