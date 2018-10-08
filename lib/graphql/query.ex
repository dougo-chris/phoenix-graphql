defmodule Bookstore.Graphql.Query do
  @moduledoc false

  use Absinthe.Schema

  alias Bookstore.Graphql.BookResolver
  alias Bookstore.Graphql.AuthorResolver
  alias Bookstore.Graphql.ReviewResolver

  import_types Bookstore.Graphql.BookType
  import_types Bookstore.Graphql.AuthorType
  import_types Bookstore.Graphql.ReviewType

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
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

    field :author, :author do
      arg :id, :id
      resolve &AuthorResolver.author_get/3
    end

    field :authors, list_of(:author) do
      arg :offset, :integer
      arg :limit, :integer
      resolve &AuthorResolver.author_list/3
    end

    field :review, :review do
      arg :id, :id
      resolve &ReviewResolver.review_get/3
    end

    field :reviews, list_of(:review) do
      arg :offset, :integer
      arg :limit, :integer
      resolve &ReviewResolver.review_list/3
    end
  end
end