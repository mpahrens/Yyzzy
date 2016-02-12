defmodule PropertyTest do
  use ExUnit.Case

  test "1 property generation" do
    alias Yyzzy.Property.SimpleScore, as: SS
    prop = Yyzzy.Property.gen(Yyzzy.Property.SimpleScore)
    player = %Yyzzy{uid: :player, properties: prop}
    assert player.properties[SS].score == 0
  end

  test "multiple properties generation" do
    alias Yyzzy.Property, as: YP
    props = YP.gen(YP.SimplePosition.Point2D)
            |> YP.gen(YP.SimplePhysics.BodyRect)
            |> YP.gen([YP.SimplePhysics.Velocity2D, YP.SimplePhysics.Acceleration2D])
    player = %Yyzzy{uid: :player, properties: props}
    assert player.properties[YP.SimplePhysics.BodyRect].height == 0
    assert player.properties[YP.SimplePhysics.Acceleration2D].x == 0
  end

  test "composite property templates" do
    alias Yyzzy.Property, as: YP
    #character template for any character entity (player, npc, etc) in the game
    every_player_props = YP.gen(YP.SimplePosition.Point3D)
                          |> YP.gen(YP.SimplePhysics.BodyRect)
    stats = fn x,y -> round(:random.uniform * x) + y end
    game = [:fighter, :rogue, :paladin, :mage, :bard, :cleric]
              |> Enum.reduce(%Yyzzy{uid: :game},fn class, acc ->
                   rpg = case class do
                      x when x in [:fighter, :rogue, :paladin] ->
                        %YP.SimpleRPGStats{str: stats.(10,5), dex: stats.(10,5), chr: stats.(10,5),
                                           mnd: stats.(10,1), int: stats.(10,1), luck: stats.(10,1),
                                           class: x}
                      y when y in [:mage, :bard, :cleric] ->
                        %YP.SimpleRPGStats{str: stats.(10,1), dex: stats.(10,1), chr: stats.(10,1),
                                           mnd: stats.(10,5), int: stats.(10,5), luck: stats.(10,5),
                                           class: y}
                    end
                  #update the game accumulator's entity fields to add a party member using just struct operations
                  %Yyzzy{acc | entities:
                    Map.put(acc.entities, class,
                      %Yyzzy{uid: class, properties: YP.append(every_player_props,rpg)})}
                end)
    game = %Yyzzy{game | entities: Map.put(game.entities, :npc, %Yyzzy{uid: :npc, properties: YP.gen(every_player_props,YP.SimpleRPGStats)})}
    assert game.entities[:rogue].properties[YP.SimpleRPGStats].class == :rogue
    assert game.entities[:npc].properties[YP.SimpleRPGStats].class == :npc
  end

  test "comprehend over properties -- nominal" do
    #Set up a game where a bunch of entities, at different levels, have the same property key

    assert true
  end
  test "comprehend over properties -- heirarchical" do
    # Some properties have the name Yyzzy.Property.Sort.Kind.Prop
      #should be able to map over these as well to simplify case based computation
    assert true
  end
  test "comprehend over properties -- fields" do
    # you to specify a list of keys to match on
    # e.g. if any yyzzy property has a field _, do: _. This can be dangerous though
    # since multiple properties (e.g. position, velocity, and accelleration) all have the
    # same pattern x, y, (z)
    assert true
  end
end
