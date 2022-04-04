local base_enemy = require('factories.base_enemy')

local drawable = love.graphics.newImage('/assets/random_xy.png')

return function (...)
  local new_enemy = base_enemy(...)

  new_enemy.class = 'random_user_xy'
  new_enemy.pw = 23
  new_enemy.ph = 32

  function new_enemy.extra_update(self, dt)
    self:walk_movement(dt, 0.5)
  end 

  function new_enemy.draw(self)
    love.graphics.draw(drawable,self.x,self.y)
  end

  function new_enemy.timer_action(self)
    self.action_timer = 5
    self.speed = 0.5
      if math.random(0, 100) > 80 then
        self.speed = 1
        local nearest = self:nearestPlayer()
        if nearest then
          local dir = point_direction(self.x, self.y, nearest.x, nearest.y)
          self.delta_x = math.cos(dir)
          self.delta_y = math.sin(dir)
        end
      else
        self.speed = 0.5
        local goal = {x = math.random(-140, 600), y = math.random(110, 160)}
        if goal then
          local dir = point_direction(self.x, self.y, goal.x, goal.y)
          self.delta_x = math.cos(dir)
          self.delta_y = math.sin(dir)
        end
      end
  end
  return new_enemy
end