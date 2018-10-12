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

## Goals

- List books, authors and reviews with nested data
- Show any book, author or review with nested data, filtered by id
- Return results with limits and offsets
- Subscribe to changes on a book
- Change a book and see the changes in a subscription

## Stages
- Create the supporting files : [STEP_1.md](STEP_1.md)
- Simple query : [STEP_2.md](STEP_2.md) `git clone https://github.com/dougo-chris/phoenix-graphql.git --branch=STEP_2`
- Complex queries : [STEP_3.md](STEP_3.md) `git clone https://github.com/dougo-chris/phoenix-graphql.git --branch=STEP_3`
- Subscriptions : [STEP_4.md](STEP_4.md) `git clone https://github.com/dougo-chris/phoenix-graphql.git --branch=STEP_4`
- Mutations : [STEP_5.md](STEP_5.md) `git clone https://github.com/dougo-chris/phoenix-graphql.git --branch=STEP_5`
