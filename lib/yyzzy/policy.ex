defmodule Yyzzy.Policy do
  @moduledoc """
    A Policy function is a function that takes 2 arguments,
    both %Yyzzy{}'s and returns either:
    {:halt, yyzzy} which means to not recurse on its child entities
    yyzzy which means to recure on its child entities
  """
  ##
  # Preservers
  def retain(y1, y2), do: y1
  def overwrite(y1, y2), do: y2
  ##
  # Metric / Heuristic policies
  @doc """
  returns the entity with the biggest timestamp
  if either don't have a time then we can't compare and the first is returned
  """
  def most_recent(y1 = %Yyzzy{metadata: %{time_updated: t1}},
                  y2 = %Yyzzy{metadata: %{time_updated: t2}}) do
    if t1 > t2, do: y1, else: y2
  end
  def most_recent(y1, y2), do: y1
  @doc """
  returns the entity with the biggest timestamp and shadows over its children
  """
  def most_recent_parent(y1, y2), do: {:halt, most_recent(y1, y2)}

end
