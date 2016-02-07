defmodule StructTest do
  use ExUnit.Case

  #What Yyzzy will do for you at the minimal level.
  test "game only" do
    game       = %Yyzzy{uid: :game}
    uid        = game.uid
    properties = game.properties
    metadata   = game.metadata
    entities   = game.entities

    assert uid        == :game
    assert properties == %{}
    assert metadata   == %{}
    assert entities   == %{}
  end
  test "game with players" do
    p1   = %Yyzzy{uid: :p1}
    p2   = %Yyzzy{uid: :p2}
    game = %Yyzzy{uid: :game, entities: %{p1: p1, p2: p2}}

    assert Enum.count(game) == 3
    assert game.entities[:p1].uid  == :p1

  end

  test "game with players and ad hoc logic" do
    #init
    p1   = %Yyzzy{uid: :p1}
    p2   = %Yyzzy{uid: :p2}
    ball = %Yyzzy{properties: %{owner: :noone}}
    game = %Yyzzy{uid: :game, entities: %{p1: p1, p2: p2, ball: ball}}

    # look, a terrible, minimal runtime system lol
    update = fn a = %Yyzzy{entities: e = %{ball: b= %Yyzzy{properties: p}}} ->
                  p = case :random.uniform * 10 do
                    x when x < 3 -> %{p | owner: :p1}
                    x when x < 6 -> %{p | owner: :p2}
                    _            -> p
                  end
                  %{a | entities: %{e | ball: %{b | properties: p}}}
              end

    game = (for _ <- 1..100, do: update.(game)) |> List.last
    assert game.entities[:ball].properties[:owner] in [:p1, :p2, :noone]

  end

  test "game with players and a score by who gets the ball" do
    #init
    score = %Yyzzy.Property.SimpleScore{}
    p1   = %Yyzzy{uid: :p1, properties: score}
    p2   = %Yyzzy{uid: :p2, properties: score}
    ball = %Yyzzy{uid: :ball, properties: %{owner: :noone}} #ad hoc property
    game = %Yyzzy{uid: :game, entities: %{p1: p1, p2: p2, ball: ball}}

    # look, a terrible, minimal runtime system lol
    update = fn a = %Yyzzy{entities: %{ball: %Yyzzy{properties: %{owner: o}}}} ->
              Enum.map(a,fn entity ->
                case entity.uid do
                  ^o ->
                    %{entity | properties: #give it a point
                           %{entity.properties |  score: entity.properties.score + 1}}
                  :ball ->
                    p = case :random.uniform * 10 do #flip a coin
                      x when x < 3 -> %{entity.properties | owner: :p1} #30% change p1 might get it
                      x when x < 6 -> %{entity.properties | owner: :p2} #30% change p2 might get it
                      _            -> entity.properties #40% chance it will stay with its current owner
                      end
                    %Yyzzy{entity | properties: p}
                  _ -> entity #do nothing
                end
              end) |> Enum.into(a) #rebuild the game tree
          end

    game = Enum.reduce(1..100, game, fn _x, acc -> update.(acc) end)
    assert game.entities[:ball].properties[:owner] in [:p1, :p2, :noone]
    assert game.entities[:p1].properties.score >= 0

  end

  test "structure is preserved over map + into: linked list" do
    bullets = %Yyzzy{uid: :bullets, properties: %{count: 10}}
    weapon = %Yyzzy{uid: :weapon, entities: %{bullets: bullets}}
    player = %Yyzzy{uid: :player, entities: %{weapon: weapon}}
    game = %Yyzzy{uid: :game, entities: %{player: player}}

    game = Enum.map(game, fn x -> %{x | metadata: %{s: :random.uniform}} end) |> Enum.into(game)
    assert game.entities[:player].entities[:weapon].entities[:bullets].properties[:count] == 10
  end
  test "structure is preserved over map and into: branching tree" do
    bullets = %Yyzzy{uid: :bullets, properties: %{count: 10}}
    gun = %Yyzzy{uid: :gun, entities: %{bullets: bullets}}
    shield = %Yyzzy{uid: :shield}
    sword =  %Yyzzy{uid: :sword}
    player = %Yyzzy{uid: :player, entities: %{gun: gun}}
    hero = %Yyzzy{uid: :hero, entities: %{sword: sword, shield: shield}}
    game = %Yyzzy{uid: :game, entities: %{player: player, hero: hero}}

    game = Enum.map(game, fn x -> %{x | metadata: %{s: :random.uniform}} end) |> Enum.into(game)
    assert game.entities[:player].uid == :player
    assert game.entities[:hero].uid == :hero
    assert game.entities[:hero].entities[:sword].uid == :sword
    assert game.entities[:hero].entities[:shield].uid == :shield
    assert game.entities[:player].entities[:gun].entities[:bullets].properties[:count] == 10
  end

  test "structure is valid over polymorphism (parent reference name != uid)" do
    #TODO
    assert true
  end
  test "uids are heirarchical (globally unique by following from root entity + locally unqiue)" do
    #TODO
    assert true
  end
  test "structure can be a template to generate" do
    #TODO
    assert true
  end
end
