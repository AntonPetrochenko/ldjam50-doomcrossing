local base_enemy = require('factories.base_enemy')

return function (...)
  local new_enemy = base_enemy(...)

  new_enemy.x = 100
  new_enemy.y = 100
  new_enemy.class = 'bird'

  function new_enemy.update(self, dt)
    self:walk_movement(dt, 0.5)
  end 

  return new_enemy
end