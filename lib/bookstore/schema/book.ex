defmodule Bookstore.Schema.Book do
  @moduledoc false

  use Ecto.Schema

  alias Bookstore.Schema.Author
  alias Bookstore.Schema.Review

  @primary_key {:id, :id, autogenerate: true}

  schema "books" do
    belongs_to :author, Author, foreign_key: :author_id

    field :title, :string
    field :pages, :integer

    has_many :reviews, Review, foreign_key: :book_id, references: :id, on_delete: :delete_all
  end
end
