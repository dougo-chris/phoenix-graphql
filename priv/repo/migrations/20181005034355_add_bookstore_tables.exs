defmodule Bookstore.Repo.Migrations.AddBookstoreTables do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add :name,         :string
      add :email,        :string
    end

    create table(:books) do
      add :author_id,     :integer
      add :title,         :string
      add :pages,         :integer
      add :likes,         :integer
    end

    create table(:reviews) do
      add :book_id,     :integer
      add :author_id,   :integer
      add :comment,     :string
      add :rating,      :integer
    end
  end
end