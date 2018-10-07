# Creating a Phoenix / GraphQL API server

## Data structure for the API

- Books
  - belongs to an author
  - has many reviews
- Authors
  - have many books
  - have many reviews
- Reviews
  - belongs to a book
  - belongs to an author

## Version 1 goals

- List books, authors and reviews with nested data
- Show any book, author or review with nested data, filtered by id
- Return results with limits and offsets

## Stages
- Create the supporting files : [STEP_1.md](STEP_1.md)
- Simple query : [STEP_2.md](STEP_2.md)
