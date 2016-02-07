defmodule Yyzzy.Collectable do
  ## TODO
  defimpl Collectable, for: Yyzzy do
    def into(original) do
      {original, fn
        group, {:cont, yyzzy} ->
          uid = yyzzy.uid
          case group.uid do
            ^uid -> yyzzy
            _ ->
              %Yyzzy{group | entities: Map.put(group.entities, uid, yyzzy)}
            end
        group, :done -> group
        _, :halt -> :ok
      end}
    end
  end
end
