defmodule Yyzzy.Property.SimpleRPGStats do
  use Yyzzy.Property
  defstruct str: 0,
            dex: 0,
            vit: 0,
            mnd: 0,
            int: 0,
            chr: 0,
            luck: 0,
            hp: 0,
            mp: 0,
            class: :npc
end
