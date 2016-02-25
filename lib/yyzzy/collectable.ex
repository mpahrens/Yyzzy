defmodule Yyzzy.Collectable do
  ## TODO
  defimpl Collectable, for: Yyzzy do
    def into(original) do
      {original, fn
        group, {:cont, yyzzy} ->
          uid = group.uid
          case yyzzy.uid do
            ^uid -> yyzzy
            {^uid, u} -> Yyzzy.put(group, u, yyzzy)
            _ ->
              Yyzzy.put(group, uid, yyzzy)
            end
        group, :done -> group
        _, :halt -> :ok
      end}
    end
  end
end
