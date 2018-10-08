defmodule Bookstore.Graphql.ReviewType do
  @moduledoc false

  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers

  @desc "reviews"
  object :review do
    field :id, :id
    field :comment, :string
    field :rating, :integer

    field :book, :book, resolve: dataloader(:item_loader, :book)
    field :author, :author, resolve: dataloader(:item_loader, :author)
  end
end