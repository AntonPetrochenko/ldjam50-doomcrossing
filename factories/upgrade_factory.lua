guns = {
  minigun = love.graphics.newImage("/assets/wpn/minigun.png")
}

local function shotgun()
  return {
    impulse = 5,
    damping = 0.96,
    cut = 5,

    spread = 3,
    spray = 1,

    number = 10,
    damage = 1,

    rate = 1,

    rumble_strength = 0.5,
    rumble_duration = 0.5
}
end

local function minigun()
  return {
    impulse = 7,
    damping = 1,
    cut = 0.2,

    spread = 1,
    spray = 0.1,

    number = 0,
    damage = 1,

    rate = 0.1,
    rumble_strength = 0.5,
    rumble_duration = 0.1
}
end


return function(x,y)
  local new_upgrade = {
    x = x,
    y = y,
  }

  new_upgrade.collides = true
  new_upgrade.pw = 8
  new_upgrade.ph = 8
  new_upgrade.on_collision = function (self, other)
    if other.isplayer then
      other.weapon = minigun()
      print('collides')
    end
  end

  new_upgrade.update = function (self, dt)
    self:finalize_motion()
  end

  new_upgrade.draw = function (self)
    love.graphics.draw(guns.minigun, self.x, self.y)
  end

  return new_upgrade
end