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