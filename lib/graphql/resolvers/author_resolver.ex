defmodule Bookstore.Graphql.AuthorResolver do
  @moduledoc false

  import Ecto.Query
  import Bookstore.Graphql.ParamsHelper

  alias Bookstore.Repo
  alias Bookstore.Schema.Author

  def author_get(_parent, %{id: id}, _resolution) do
    case Repo.get_by(Author, id: id) do
      %Author{} = author ->
        {:ok, author}
      _ ->
        {:error, "Author not found"}
    end
  end

  def author_get(_parent, _args, _resolution) do
    {:error, "Invalid parameters"}
  end

  def author_list(_parent, args, _resolution) do
    {offset, limit} = offset_limit(args)

    authors =
      Author
      |> offset([_], ^offset)
      |> limit([_], ^limit)
      |> Repo.all()

    {:ok, authors}
  end

end