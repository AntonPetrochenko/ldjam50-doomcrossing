return function (x,y)
  local enemy = {}
  enemy.x = x
  enemy.y = y
  enemy.z = 0

  local players = {
    {
      availability = true,
      playerobj = {
        x = 10,
        y = 10,
      }
    },
    {
      availability = false,
      playerobj = {
        x = 50,
        y = 50,
      }
    },
    {
      availability = false,
      playerobj = {
        x = 30,
        y = 30,
      }
    }
  }

  function enemy.nearestPlayer(self)
    local min = 100000000000000000000
    local cords = {}
    for i,v in pairs(joysticks) do
      if v.availability == false then
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
    dump(self:nearestPlayer())
  end

  function enemy.draw(self, dt)
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle("fill", self.x,self.y, self.x,self.y)
    love.graphics.setColor(1,1,1,1)
  end

  return enemy
end