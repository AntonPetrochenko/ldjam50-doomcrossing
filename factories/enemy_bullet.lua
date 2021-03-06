local gradient = require 'gradient_mesh'
local collider = require 'enemy_collider'

local bullet_gradient = gradient('horizontal', {0.5,0,0,0},{0.74,0.76,0.13,1}, {1,0,0,1}, {0.5,0.35,0.75,1}, {0,0,1,1})

return function (x,y,vel, damping, angle, cut)
  local new_bullet = {}

  new_bullet.x = x
  new_bullet.y = y

  new_bullet.health = 1

  new_bullet.damping = damping -- 1

  new_bullet.angle = angle -- kakoy nravitsya

  new_bullet.vel = vel --p do p

  new_bullet.is_enemy = true

  new_bullet.collides = true
  new_bullet.pw = 8
  new_bullet.ph = 8
  new_bullet.on_collision = collider

  new_bullet.life = cut

  function new_bullet.update(self, dt)

    self.vel = self.vel * self.damping

    self.life = self.life - dt

    self.x = self.x + math.cos(angle)*self.vel
    self.y = self.y + math.sin(angle)*self.vel

    self:finalize_motion()

    if self.life < 0 or self.health < 0 then
      self.damping = 0.9
    end
    
    if self.vel < 0.1 then world:del(self) end
  end

  function new_bullet.draw(self)

    local length = 8 * (  math.log( math.pow(self.vel, 0.6)  ) + 1.5 )

    love.graphics.draw(bullet_gradient, self.x+4, self.y+4, self.angle, length, 8, 0.5, 0.5 )
  end
  return new_bullet
end