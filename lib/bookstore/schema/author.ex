defmodule Bookstore.Schema.Author do
  @moduledoc false

  use Ecto.Schema

  alias Bookstore.Schema.Book
  alias Bookstore.Schema.Review

  @primary_key {:id, :id, autogenerate: true}

  schema "authors" do
    field :name,  :string
    field :email, :string

    has_many :books,    Book,   foreign_key: :author_id, references: :id, on_delete: :delete_all
    has_many :reviews,  Review, foreign_key: :author_id, references: :id, on_delete: :delete_all
  end
end
