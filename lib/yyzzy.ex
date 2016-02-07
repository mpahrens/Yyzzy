defmodule Yyzzy do
  defstruct uid: nil, properties: %{}, metadata: %{}, entities: %{}

  @doc """
    applies the function to every entity in the tree yyzzy and then
    rebuilds the structure
  """
  def map_into(yyzzy, fun), do: Enum.map(yyzzy, fun) |> Enum.into(yyzzy)

end
