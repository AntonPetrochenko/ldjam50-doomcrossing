local base_enemy = require('factories.base_enemy')

local left_border = -140
local right_border = 600
local dir_right = false

return function (...)
  local new_enemy = base_enemy(...)

  new_enemy.class = 'ebanat'

  function new_enemy.walk_movement()
      if dir_right then
        self.x = self.x + 0.5
      else
        self.x = self.x - 0.5
      end
  end
  function new_enemy.update(self, dt)
    if self.x < left_border then
        dir_right = true
    end
    if self.y < right_border then
        dir_right = false
    end
  end 

  return new_enemy
end