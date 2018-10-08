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