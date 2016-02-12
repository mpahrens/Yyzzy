defmodule Yyzzy do
  defstruct uid: nil, properties: %{}, metadata: %{}, entities: %{}

  @doc """
    applies the function to every entity in the tree yyzzy and then
    rebuilds the structure
  """
  def map_into(yyzzy, fun), do: Enum.map(yyzzy, fun) |> Enum.into(yyzzy)
  @doc """
    applies the function to every entity in the tree yyzzy
    iff the entities has the property key specified by
    opts = [properties: [Property1, Property2]]
    or leaves the entity alone otherwise and then rebuilds the structure.
    if opts are supplied, then it behaves like map_into
  """
  def map_over_into(yyzzy, fun, opts) do
    case opts do
      [property: property] -> map_over_into(yyzzy, fun, properties: [property])
      [kind: kind] -> map_over_into(yyzzy, fun, kinds: [kind])
      [properties: props] ->
        fun2 = fn y ->
          keys = props -- Map.keys(y.properties)
          case keys do
            [] -> fun.(y)
            _ -> y
          end
        end
      [kinds: kinds] ->
        fun2 = fn y ->
          if(contains_keys?(kinds,Map.keys(y.properties))) do
            fun.(y)
          else
            y
          end
        end
      _ -> map_into(yyzzy, fun)
    end
  end
  defp contains_keys?([], _), do: false
  defp contains_keys?(kinds,keys) do
    [kind | tail] = kinds
    if (Enum.reduce(keys, false, fn x, acc ->
      case kind -- Module.split(x) do
        [] -> true or acc
        _ -> false or acc
      end
    end)) do
      true
    else
      contains_keys?(tail, keys)
    end
  end

end
