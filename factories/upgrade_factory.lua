drawables = {
  minigun = love.graphics.newImage("/assets/wpn/minigun.png"),
  shotgun = love.graphics.newImage("/assets/wpn/shotgun.png"),
  double = love.graphics.newImage("/assets/wpn/double.png"),
  rate = love.graphics.newImage("/assets/wpn/rate.png"),
  far = love.graphics.newImage("/assets/wpn/far.png"),
}



local function shotgun() return {
    impulse = 5,
    damping = 0.96,
    cut = 5,

    spread = 3,
    spray = 1,

    number = 10,
    damage = 1,

    rate = 1,

    rumble_strength = 0.5,
    rumble_duration = 0.5,

    spread_amount = 0.3
} end

local function minigun() return {
    impulse = 7,
    damping = 1,
    cut = 0.1,

    spread = 4,
    spray = 0.1,

    number = 1,
    damage = 1,

    rate = 0.1,
    rumble_strength = 0.5,
    rumble_duration = 0.1,

    spread_amount = 1.4
  } end

local function set_all_values(source,target)
  for index, value in pairs(source) do
    target[index] = source[index]
  end
end

local fupgrades = {
  double = function(player)
    local weapon = player.weapon
    weapon.spray = weapon.spray * weapon.spread_amount
    weapon.number = weapon.number + 1
    weapon.rate = weapon.rate * 1.3
  end,
  rate = function(player)
    local weapon = player.weapon
    weapon.spray = weapon.spray * 1.2
    weapon.rate = weapon.rate * 0.9
    weapon.spread = weapon.spread * weapon.spread_amount
  end,
  far = function(player)
    local weapon = player.weapon
    weapon.spray = weapon.spray * 0.8
    weapon.rate = weapon.rate * 0.9
    weapon.spread = weapon.spread * weapon.spread_amount
  end,
  minigun = function(player)
    local weapon = player.weapon

    player.stash = player.weapon
    player.weapon = minigun()
    player.wpnbonustimer = 5
  end,
  shotgun = function(player)
    local weapon = player.weapon

    player.stash = player.weapon
    player.weapon = shotgun()
    player.wpnbonustimer = 10
    
  end
}


return function(x,y,type)
  local new_upgrade = {
    x = x,
    y = y,
  }

  new_upgrade.type = type

  new_upgrade.collides = true
  new_upgrade.pw = 8
  new_upgrade.ph = 8
  new_upgrade.on_collision = function (self, other)
    if other.isplayer then
      fupgrades[type](other)
      world:del(self)
    end
  end

  new_upgrade.update = function (self, dt)
    if self.x < -140 then
      self.x = -140
  end
  if self.x > 600 then
      self.x = 600
  end
  if self.y < 110 then
      self.y = 110 
  end
  if self.y > 160 then
      self.y = 160
  end
    self:finalize_motion()
  end

  new_upgrade.draw = function (self)
    love.graphics.draw(drawables[type], self.x, self.y)
  end

  return new_upgrade
end