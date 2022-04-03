local base_enemy = require('factories.base_enemy')
local enemy_bullet = require 'factories.enemy_bullet'

local drawable = love.graphics.newImage('/assets/shooter.png')

return function (...)
  local new_enemy = base_enemy(...)

  new_enemy.class = 'random_user_xy'
  new_enemy.pw = 25
  new_enemy.ph = 29

  new_enemy.shoot_x = 24/2
  new_enemy.shoot_y = 32/2
  new_enemy.weapon = {
    impulse = 2,
    damping = 1,
    cut = 0.1,

    spread = 1,
    spray = 0.1,

    number = 1,
    damage = 1,

    rate = 0.3,
    rumble_strength = 0.5,
    rumble_duration = 0.1,

    spread_amount = 1.2
}

  function new_enemy.extra_update(self, dt)
    self:walk_movement(dt)
  end 

  function new_enemy.draw(self)
    love.graphics.draw(drawable,self.x,self.y)
  end

  function new_enemy.timer_action(self)
    self.speed = 0.5
    self.action_timer = 0.5
    if math.random(0, 100) > 80 then
      self.delta_x = 0
      self.delta_y = 0
      local spread_velocity = self.weapon.impulse - (math.random()-0.5)*self.weapon.spread
      world:add(enemy_bullet(self.x+self.shoot_x, self.y+self.shoot_y, spread_velocity, self.weapon.damping, 1, self.weapon.cut))
      world:add(enemy_bullet(self.x+self.shoot_x, self.y+self.shoot_y, spread_velocity, self.weapon.damping, 2, self.weapon.cut))
      world:add(enemy_bullet(self.x+self.shoot_x, self.y+self.shoot_y, spread_velocity, self.weapon.damping, 4, self.weapon.cut))
      world:add(enemy_bullet(self.x+self.shoot_x, self.y+self.shoot_y, spread_velocity, self.weapon.damping, 3, self.weapon.cut))
      world:add(enemy_bullet(self.x+self.shoot_x, self.y+self.shoot_y, spread_velocity, self.weapon.damping, 5, self.weapon.cut))
      world:add(enemy_bullet(self.x+self.shoot_x, self.y+self.shoot_y, spread_velocity, self.weapon.damping, 6, self.weapon.cut))
    else
      self.speed = 0.5
      local nearest = self:nearestPlayer()
      if nearest then
        local dir = point_direction(self.x, self.y, nearest.x, nearest.y)
        self.delta_x = math.cos(dir)
        self.delta_y = math.sin(dir)
      end
    end
  end
  return new_enemy
  
end