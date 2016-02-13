defmodule ModuleTest do
  use ExUnit.Case
  @moduledoc """
  test the Yyzzy module non-protocol functions
  """
  test "update a property inplace" do
    alias Yyzzy.Property, as: YP
    player = %Yyzzy{uid: :player, properties: YP.gen(YP.SimpleScore)}
    assert player.properties[YP.SimpleScore].score == 0
    player = %Yyzzy{player | properties: YP.update(player.properties,
                                    YP.SimpleScore, :score, fn _ -> 100 end)}
    assert player.properties[YP.SimpleScore].score == 100
  end
  test "merge two Yyzzy entities together with some policy" do
    alias Yyzzy.Property, as: YP
    props = YP.gen(YP.SimpleScore)
    low_score = YP.update(props, YP.SimpleScore, :score, fn _ -> 100 end)
    hi_score = YP.update(props, YP.SimpleScore, :score, fn _ -> 2000 end)
    good_player = %Yyzzy{uid: :player1,
                properties: low_score}
    great_player = %Yyzzy{uid: :player2,
                properties: hi_score}

    server1 = %Yyzzy{uid: :game, entities: %{player1: %{good_player | metadata: %{time: 100}},
                                        player2: %{great_player | metadata: %{time: 50}}}}
    server2 = %Yyzzy{uid: :game, entities: %{player1: %{great_player | metadata: %{time: 50}},
                                        player2: %{good_player | metadata: %{time: 100}}}}

    assert server1.entities[:player1].properties[YP.SimpleScore].score == 100
    assert server1.entities[:player2].properties[YP.SimpleScore].score == 2000
    assert server2.entities[:player1].properties[YP.SimpleScore].score == 2000
    assert server2.entities[:player2].properties[YP.SimpleScore].score == 100
    server_merged = Yyzzy.merge(server1, server2, fn y1, y2 ->
      if y1.metadata[:time] > y2.metadata[:time] do
        y1
      else
        y2
      end
    end)
    assert server_merged.entities[:player1].properties[YP.SimpleScore].score == 100
    assert server_merged.entities[:player2].properties[YP.SimpleScore].score == 100
  end

end
