#game entities
inital_ball_position =  %{x: 5, y: 10}
world = %Yyzzy.Entity{uid: :world, properties: %{size: %{length: 10, width: 20}, score: %{player: 0, enemy: 0}, points_to_win: 10}}
ball = %Yyzzy.Entity{uid: :ball, properties: %{size: %{length: 1, width: 1}, position: inital_ball_position}}
enemy = %Yyzzy.Entity{uid: :enemy, properties: %{size: %{length: 3, width: 1}, position: %{x: 20, y: 5}}
player = %Yyzzy.Entity{uid: :player, properties: %{size: %{length: 3, width: 1}, position: %{x: 0, y: 5}}

#scoring points
update_points = fn
  %{world: w, ball: b} = entities ->
    new_score = case b.properties.position.x do
              0 -> %{w.score | enemy: w.score.enemy + 1}
              w.properties.size.length - 1 -> %{w.score | player: w.score.player + 1}
              _ -> w.properties.score
            end
    update_status = case new_score do
      %{player: p, enemy: e} when p >= 10 || e >= 10 -> Map.put(w.metadata, :status, :gameover)
      _ -> w.metadata
    end
    w = %{w | score: new_score, metadata: update_status}
    %{entities | world: w}
  end

update_ball_physics = fn
  %{world: w, ball: b, player: p, enemy: e} = entities ->
    %{length: l, width: w} = w.properties.size
    wall_check = fn %{x: x, y: y} ->
      new_y = case y do
        y when y >= l -> l
        y when y <= 0 -> 0
        y -> y
      end
      %{x: x, y: y}
    end
    #six cases: new ball, enemy point, player point, enemy paddle, player paddle, midgame
    player_y = p.properties.position.y
    enemy_y = e.properties.position.y
    player_range = (player_y - div(p.properties.size.length,2))..(player_y + div(p.properties.size.length,2))
    enemy_range = (enemy_y - div(e.properties.size.length,2))..(enemy_y + div(e.properties.size.length,2))
    {position, velocity} = case {b.position, b.metadata[:velocity]} do
       {%{x: x, y: y}, nil} ->
         dx = :math.pow(-1,:random.uniform(2) -1) # -1 | 1
         dy = :math.pow(-1,:random.uniform(2) -1)

      {%{x: 0,y: y}, %{dx: dx, dy: dy}} when y in player_range -> #player pong
        dx = -dx
        {%{x: x+dx, y: y+dy},%{dx: dx, dy: dy}}
      {%{x: w,y: y}, %{dx: dx, dy: dy}} when y in enemy_range -> #enemy pong
        dx = -dx
        {%{x: x+dx, y: y+dy},%{dx: dx, dy: dy}}
      {%{x: 0}, _} ->
        {inital_ball_position, nil} # goes to newball state
      {%{x: w}, _} ->
        {inital_ball_position, nil} # also goes to newball state
      {%{x: x, y: y}, %{dx: dx, dy: dy}} ->
        {%{x: x+dx, y: y+dy},%{dx: dx, dy: dy}}
       end
      #return
      %{entities |
        ball: %{b |
          properties: %{b.properties | position: wall_check(position)},
          metadata: Map.put(b.metadata, :velocity, velocity)}
        }
    end
  #specific
  move_enemy = fn
    %{world: w, ball: b, enemy: e} = entities ->
      #move towards the ball's y position, with some noise
      new_enemy_position = cond do
        b.properties.position.y > e.properties.position.y ->
          %{e.properties.position | e.properties.position.y +
            (:random.uniform(2) - 1)} #50% chance of going up
        true -> %{e.properties.position | e.properties.position.y -
            (:random.uniform(2) - 1)} #50% chance of going down
      end
      #normalize to be within the bounds of the screen
      %{length: l, width: w} = w.properties.size
      wall_check = fn %{x: x, y: y} ->
        new_y = case y do
          y when y >= l -> l
          y when y <= 0 -> 0
          y -> y
        end
        %{x: x, y: y}
      end
      %{entities |
        enemy: %{e | properties: %{
          e.properties | position: wall_check.(new_enemy_position) #ignore paddle length for now
        }}}
    end
