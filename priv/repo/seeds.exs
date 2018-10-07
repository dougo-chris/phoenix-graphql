# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Bookstore.Repo.insert!(%Bookstore.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

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