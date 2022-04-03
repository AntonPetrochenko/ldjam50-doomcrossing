local bird_enemy = require('factories.base_enemy')

return function (...)
  local new_enemy = bird_enemy(...)

  new_enemy.x = 100
  new_enemy.y = 100
  new_enemy.class = 'bird'

  return new_enemy
end