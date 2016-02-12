defmodule Yyzzy.Property do
  @moduledoc """
    A set of common entity properties that can be used to standardize your game.

    An entity's property field is composed of multiple property structs.
    This module provides some helpers to generate the properties map.
  """
  @doc """
  usage: properties = gen([SimpleScore, SimplePosition, SimplePhysics])

  OR to make it easier to "build"

  properties = old_properties |>
    gen([SimpleScore, SimpleHighScore])
    gen([SimplePosition, SimplePhysics])
    gen([SimpleAI, SimpleRPGStats])

  and this generates a map that looks like:
  %{simple_score: %{score: 0}, simple_high_score: %{high_score: 0} ...}
  """
  def gen(item) when is_atom(item), do: gen([item])
  def gen(list) when is_list(list), do: gen(%{}, list)
  def gen(map, [h | t]) when is_map(map) do
    map = Map.merge(map, %{h => h.new })
    gen(map,t)
  end
  def gen(map, item) when is_atom(item) and is_map(map), do: gen(map, [item])
  def gen(map, []) when is_map(map), do: map
  def merge(map1, map2), do: Map.merge(map1, map2)
  def append(map, prop) do
    %{__struct__: key} = prop
    Map.put(map, key, prop)
  end
  defmacro __using__(_opts) do
    quote do
      @before_compile Yyzzy.Property
    end
  end
  defmacro __before_compile__(_env) do
    quote do
      def new, do: %__MODULE__{}
    end
  end

end
