local base_enemy = require('factories.base_enemy')

return function (...)
  local new_enemy = base_enemy(...)

  new_enemy.class = 'random_user_xy'

  function new_enemy.extra_update(self, dt)
    self:walk_movement(dt)
  end 

  function new_enemy.timer_action(self)
    self.speed = 0.5
    self.action_timer = 0.5
    if math.random(0, 100) > 80 then
      self.action_timer = 1
      self.x = self.x
      self.y = self.y
    else
      self.speed = 0.5
      local nearest = self:nearestPlayer()
      if nearest then
        local dir = point_direction(self.x, self.y, nearest.x, nearest.y)
        self.delta_x = math.cos(dir)
        self.delta_y = math.sin(dir)
        self.action_timer = 0.5
      end
    end
  end
  return new_enemy
end