return function (x,y)
  local enemy = {}
  enemy.x = x
  enemy.y = y
  enemy.z = 0

  enemy.is_enemy = true

  enemy.collides = true
  enemy.pw = 24
  enemy.ph = 32

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

  function enemy.walk_movement(self, dt, speed)
    
    local nearest = self:nearestPlayer()
    if nearest then
      local dir = point_direction(self.x, self.y, nearest.x, nearest.y)

      self.x = self.x + math.cos(dir) * speed
      self.y = self.y + math.sin(dir) * speed
    end
  end

  function enemy.draw(self, dt)
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle("fill", self.x,self.y, 8, 8)
    love.graphics.setColor(1,1,1,1)
  end

  return enemy
end