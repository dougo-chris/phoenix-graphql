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