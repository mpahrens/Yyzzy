defmodule Yyzzy do
  defstruct uid: nil, properties: %{}, metadata: %{}, entities: %{}

  ##
  # Higher Order Functions

  ##
  # Mapping and restructuring

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
  def map_over_into(yyzzy, fun, property: property), do: map_over_into(yyzzy, fun, properties: [property])
  def map_over_into(yyzzy, fun, kind: kind), do: map_over_into(yyzzy, fun, kinds: [kind])
  def map_over_into(yyzzy, fun, properties: props) do
    f = fn y ->
      keys = props -- Map.keys(y.properties)
      case keys do
        [] -> fun.(y)
        _ -> y
      end
    end
    map_over_into(yyzzy, f, [])
  end
  def map_over_into(yyzzy, fun, kinds: kinds) do
    f = fn y ->
          if(contains_keys?(kinds,Map.keys(y.properties))) do
            fun.(y)
          else
            y
          end
        end
    map_over_into(yyzzy,f,[])
  end
  def map_over_into(yyzzy,fun,[]), do: map_into(yyzzy, fun)
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

  ##
  # Merging and Reduction
  @doc """
  iterate, BFS, over two Yyzzy objects that have the same root uid
  add the children
  """
  def merge(yyzzy1 = %Yyzzy{entities: e1}, yyzzy2 = %Yyzzy{entities: e2}, policy \\ Yyzzy.Policy.overwrite) do
    case policy.(yyzzy1, yyzzy2) do
      {:halt, y} -> y
      y ->
      entities = Enum.reduce(e2,e1, fn {key,y}, acc ->
        case Map.get(acc,key) do
          nil -> Map.put(acc, key, y)
          x   -> Map.put(acc, key, merge(x,y,policy))
        end
      end)
      %Yyzzy{y | entities: entities}
    end
  end
end
