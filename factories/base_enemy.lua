local upgrade = require 'factories.upgrade_factory'

return function (x,y)
  local enemy = {}
  enemy.x = x
  enemy.y = y
  enemy.z = 0

  enemy.health = 5

  enemy.is_enemy = true

  enemy.collides = true
  enemy.pw = 8
  enemy.ph = 8

  enemy.speed = 1

  enemy.delta_x = 0
  enemy.delta_y = 0

  enemy.action_timer = 1

  function enemy.nearestPlayer(self)
    local min = 100000000000000000000
    local cords = nil
    for i,v in pairs(joysticks) do
      if v.available == false then
        distance = math.sqrt( math.pow((enemy.x - v.playerobj.x), 2) + math.pow((enemy.y - v.playerobj.y), 2) )
        if distance < min then
          min = distance
          cords = v.playerobj
        end
      end
    end
    return cords
  end

  function enemy.update(self, dt)
    self:extra_update(dt)
    enemy.action_timer = enemy.action_timer - dt
    if enemy.action_timer < 0 then
      enemy:timer_action()
    end

    if self.health < 0 then
      world:del(self)

      if math.random() < 0.2 then
        local rnd_upg = {'far', 'rate', 'double', 'shotgun', 'minigun'}
        world:add(upgrade(self.x, self.y,rnd_upg[math.random(1,5)]))
      end
    end
  end

  function enemy.on_collision(self, other)
    if other.is_bullet then
      other.is_bullet = false
      other.damping = 0.3
      self.health = self.health - 1
    end

    if other.is_player then

      other.knockvx = self.delta_x
      other.knockvz = 1

      
      other.stamina = other.stamina - 1
      print(other.stamina .. '> 0', other.stamina > 0)
      if other.stamina > 0 then
        
          other:setstate("hit1")
      else
          other:setstate("knockover")
      end
      world:del(self)
    end
  end

  function enemy.walk_movement(self, dt)
    self.x = self.x + self.delta_x * self.speed
    self.y = self.y + self.delta_y * self.speed
    self:finalize_motion()
  end

  function enemy.draw(self, dt)
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle("fill", self.x,self.y, 8, 8)
    love.graphics.setColor(1,1,1,1)
  end

  return enemy
end