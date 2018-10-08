defmodule Bookstore.Graphql.AuthorType do
  @moduledoc false

  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers

  @desc "authors"
  object :author do
    field :id, :id
    field :name, :string
    field :email, :string

    field :books, list_of(:book) do
      arg :offset, :integer
      arg :limit, :integer
      resolve dataloader(:list_loader, :books)
    end

    field :reviews, list_of(:review) do
      arg :offset, :integer
      arg :limit, :integer
      resolve dataloader(:list_loader, :reviews)
    end

  end
end