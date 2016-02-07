defmodule Yyzzy.Enum do
  ### Protocols and Behaviors: Enum
  ## Note, this implementation might have to change if we want fully qualified uids..
  defimpl Enumerable, for: Yyzzy do
    def count(yyzzy) do
      {:ok, Enum.reduce(yyzzy,0,fn _x, acc -> acc+1 end) }
    end
    @doc """
      entities are in a tree like form so membership is done via DFS
    """
    def member?(_, nil), do: {:ok, false}
    def member?(%Yyzzy{uid: uid}, value) when is_atom(value) and uid == value, do: {:ok, true}
    def member?(e, value) when is_atom(value) do
      {:ok, Enum.reduce_while(e, false, fn x, _acc ->
        case x.uid == value do
          true -> {:halt, true}
          false -> {:cont, false}
        end
      end)}
    end
    def member?(yyzzy, %Yyzzy{uid: value}), do: member?(yyzzy, value)
    def member?(_,_), do: {:error, __MODULE__}

    @doc """
    reduce is done via DFS and has three cases:
      Root node, many children
      level of nodes which may have children
      level of only leafs
    """
    def reduce(_,     {:halt, acc}, _fun),   do: {:halted, acc}
    def reduce(yyzzy,  {:suspend, acc}, fun), do: {:suspended, acc, &reduce(yyzzy, &1, fun)}
    def reduce(y = %Yyzzy{entities: es}, {:cont, acc}, fun) when map_size(es) == 0  do
       {:cont, acc} = fun.(y, acc)
       {:done, acc}
     end
    def reduce(y = %Yyzzy{entities: es},  {:cont, acc}, fun) do
      new_acc = fun.(y,acc)
      [h | rest] = Map.values(es)
      rest = for child <- rest, into: %{}, do: {child.uid, child}
      new_y = %Yyzzy{h | entities: Map.merge(h.entities, rest)}
      reduce(new_y, new_acc, fun)
    end
  end

end
