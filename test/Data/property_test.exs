defmodule PropertyTest do
  use ExUnit.Case

  test "1 property generation" do
    prop = Yyzzy.Property.gen(SimpleScore)
    player = %Yyzzy{properties: prop}
    assert player.properties[:simple_score].score == 0
  end
end
