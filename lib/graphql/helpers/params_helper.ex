defmodule Bookstore.Graphql.ParamsHelper do
  @moduledoc false

  @limit_default 10

  def offset_limit(%{offset: offset, limit: limit}), do: {offset, limit}
  def offset_limit(%{offset: offset}), do: {offset, @limit_default}
  def offset_limit(%{limit: limit}), do: {0, limit}
  def offset_limit(_), do: {0, @limit_default}

end