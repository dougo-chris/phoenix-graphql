defmodule Bookstore.Schema.Review do
  @moduledoc false

  use Ecto.Schema

  alias Bookstore.Schema.Author
  alias Bookstore.Schema.Book

  schema "reviews" do
    belongs_to :author, Author, foreign_key: :author_id
    belongs_to :book,   Book,   foreign_key: :book_id

    field :comment, :string
    field :rating,  :integer
  end
end
