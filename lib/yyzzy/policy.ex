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

end
