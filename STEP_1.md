## Create the supporting files

#### Create a new Phoenix project

```
mix phx.new --no-brunch --database mysql bookstore
```

#### Add the mix dependancies

Edit `mix.exs`

```
  {:absinthe, "~> 1.4"},
  {:absinthe_plug, "~> 1.4"},
  {:absinthe_phoenix, "~> 1.4.0"},
  {:dataloader, "~> 1.0.0"},

  {:faker, "~> 0.11.0", only: [:dev, :test]},
```

Run `mix deps.get`

#### Add the migration and database tables

`mix ecto.gen.migration add_bookstore_tables`

Edit `priv/repo/migrations/YYYYMMDDHHMMSS_add_bookstore_tables.exs`

```
defmodule Bookstore.Repo.Migrations.AddBookstoreTables do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add :name,  :string
      add :email, :string
    end

    create table(:books) do
      add :author_id, :integer
      add :title,     :string
      add :pages,     :integer
      add :likes,     :integer
    end

    create table(:reviews) do
      add :book_id,   :integer
      add :author_id, :integer
      add :comment,   :string
      add :rating,    :integer
    end
  end
end
```

Edit `lib/bookstore/schema/author.ex`

```
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
```

Edit `lib/bookstore/schema/book.ex`

```
defmodule Bookstore.Schema.Book do
  @moduledoc false

  use Ecto.Schema

  alias Bookstore.Schema.Author
  alias Bookstore.Schema.Review

  @primary_key {:id, :id, autogenerate: true}

  schema "books" do
    belongs_to :author, Author, foreign_key: :author_id

    field :title,         :string
    field :pages,         :integer

    has_many :reviews, Review, foreign_key: :book_id, references: :id, on_delete: :delete_all
  end
end
```

Edit `lib/bookstore/schema/review.ex`

```
defmodule Bookstore.Schema.Review do
  @moduledoc false

  use Ecto.Schema

  alias Bookstore.Schema.Author
  alias Bookstore.Schema.Book

  schema "reviews" do
    belongs_to :author, Author, foreign_key: :author_id
    belongs_to :book,   Book,   foreign_key: :book_id

    field :comment,     :string
    field :rating,      :integer
  end
end
```

#### Build dummy data using seeds

Edit `priv/repo/seeds.exs`

```
authors = Enum.map(0 .. 50, fn _ ->
  Bookstore.Repo.insert!(%Bookstore.Schema.Author{name: Faker.Name.name(), email: Faker.Internet.email()})
end)

books = Enum.map(0 .. 200, fn _ ->
  author = Enum.random(authors)
  pages = :rand.uniform(1000)
  Bookstore.Repo.insert!(%Bookstore.Schema.Book{author_id: author.id, title: Faker.Superhero.name(), pages: pages})
end)

Enum.map(0 .. 200, fn _ ->
  book = Enum.random(books)
  author = Enum.random(authors)
  rating = :rand.uniform(10)
  comment = Faker.Lorem.sentence()
  Bookstore.Repo.insert!(%Bookstore.Schema.Review{author_id: author.id, book_id: book.id, comment: comment, rating: rating})
end)
```

#### Create and seed the database

```
mix ecto.create
mix ecto.migrate
mix run priv/repo/seeds.exs
```

