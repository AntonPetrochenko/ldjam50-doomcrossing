local gradient = require 'gradient_mesh'

local bullet_gradient = gradient('horizontal', {0.5,0,0,0},{1,0,0,1}, {1,1,0,1}, {1,1,1,1}, {1,1,1,1})

return function (x,y,vel, damping, angle)
  new_bullet = {}

  new_bullet.x = x
  new_bullet.y = y

  new_bullet.angle = angle

  new_bullet.vel = vel

  new_bullet.collides = true
  new_bullet.pw = 8
  new_bullet.ph = 8
  new_bullet.on_collision = function (self, other)
    if other.isplayer then
      return
    else
      return --world:del(self)
    end
  end

  new_bullet.life = 5

  function new_bullet.update(self, dt)

    self.vel = self.vel * damping

    self.life = self.life - dt

    self.x = self.x + math.cos(angle)*self.vel
    self.y = self.y + math.sin(angle)*self.vel

    self:finalize_motion()

    
    if self.life < 0 then world:del(self) end
  end

  function new_bullet.draw(self)
    love.graphics.draw(bullet_gradient, self.x, self.y, self.angle, 8*self.vel/2, 8, 0, 0 )
  end
  return new_bullet
end