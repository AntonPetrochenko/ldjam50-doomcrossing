local base_enemy = require('factories.base_enemy')

local drawable = love.graphics.newImage('/assets/player_xy.png')

return function (...)
  local new_enemy = base_enemy(...)

  new_enemy.class = 'user_xy'

  function new_enemy.extra_update(self, dt)
    self:walk_movement(dt)
    self.speed = 0.5
  end 
  
  function new_enemy.draw(self)
    love.graphics.draw(drawable,self.x,self.y)
  end

  function new_enemy.timer_action(self)
    self.action_timer = 3
    local nearest = self:nearestPlayer()
    if nearest then
      local dir = point_direction(self.x, self.y, nearest.x, nearest.y)

      self.delta_x = math.cos(dir)
      self.delta_y = math.sin(dir)
    end
  end
  return new_enemy
end