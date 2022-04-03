local base_enemy = require('factories.base_enemy')

return function (...)
  local new_enemy = base_enemy(...)

  new_enemy.class = 'ebabat'

  function new_enemy.extra_update(self, dt)
    self:walk_movement(dt)
    self.speed = 1
    if self.x < -160 then
      self.delta_x = 1
      self.delta_y = 0
    end

    if self.x > 630 then
      self.delta_x = -1
      self.delta_y = 0
    end
  end 

  function new_enemy.timer_action(self)
    self.action_timer = 100000000000
  end
  return new_enemy
end