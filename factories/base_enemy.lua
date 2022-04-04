local upgrade = require 'factories.upgrade_factory'
local collider = require 'enemy_collider'

return function (x,y)
  local enemy = {}
  enemy.x = x
  enemy.y = y
  enemy.z = 0

  enemy.health = 3

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

  enemy.on_collision = collider

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