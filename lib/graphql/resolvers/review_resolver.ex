defmodule Bookstore.Graphql.ReviewResolver do
  @moduledoc false

  import Ecto.Query
  import Bookstore.Graphql.ParamsHelper

  alias Bookstore.Repo
  alias Bookstore.Schema.Review

  def review_get(_parent, %{id: id}, _resolution) do
    case Repo.get_by(Review, id: id) do
      %Review{} = review ->
        {:ok, review}
      _ ->
        {:error, "Review not found"}
    end
  end

  def review_get(_parent, _args, _resolution) do
    {:error, "Invalid parameters"}
  end

  def review_list(_parent, args, _resolution) do
    {offset, limit} = offset_limit(args)

    reviews =
      Review
      |> offset([_], ^offset)
      |> limit([_], ^limit)
      |> Repo.all()

    {:ok, reviews}
  end

end