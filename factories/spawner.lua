local left_border = -160
local right_border = 620
local bottom_border = 180

local gameTimer = 0

local enemy_spawnTimer = 0
local enemy_spawnrate_inc = 0.96
local enemy_spawnDuration = 5
local enemy_1_factory = require 'factories.player_xy_enemy'
local enemy_2_factory = require 'factories.ebabat_enemy'
local enemy_3_factory = require 'factories.random_xy_enemy'
local enemy_4_factory = require 'factories.shooting_enemy'

local function spawn_enemy_1()
    world:add(enemy_1_factory(math.random(left_border, right_border), bottom_border))
end
local function spawn_enemy_2()
    local hui = math.random( 0, 1)
    if hui == 0 then
        world:add(enemy_2_factory(-200, 130))
    else
        world:add(enemy_2_factory(700, 130))
    end
end
local function spawn_enemy_3()
    world:add(enemy_3_factory(math.random(left_border, right_border), bottom_border))
end
local function spawn_enemy_4()
    world:add(enemy_4_factory(math.random(left_border, right_border), 130))
end

local function spawn()
    local hui = math.random(1, 4)
    if hui == 1 then
        spawn_enemy_1()
    elseif hui == 2 then
        spawn_enemy_2()
    elseif hui == 3 then
        spawn_enemy_3()
    elseif hui == 4 then
        spawn_enemy_4()
    end
end

return {
    update = function(dt)
        if gameTimer > 60 then
            gameTimer = 20
        end
        gameTimer = gameTimer + dt
        enemy_spawnTimer = enemy_spawnTimer + dt
        local alivePlayers = 0
        for i,v in pairs(joysticks) do
            if not v.available then
                alivePlayers = alivePlayers + 1
            end
        end
        if enemy_spawnTimer > (enemy_spawnDuration * math.pow(enemy_spawnrate_inc, gameTimer) * math.pow(0.8, alivePlayers - 1)) then
            enemy_spawnTimer = 0
            spawn()
        end

        if love.keyboard.isDown('9') then
            spawn()
        end
        if love.keyboard.isDown('1') then
            spawn_enemy_1()
        end
        if love.keyboard.isDown('2') then
            spawn_enemy_2()
        end
        if love.keyboard.isDown('3') then
            spawn_enemy_3()
        end
        if love.keyboard.isDown('4') then
            spawn_enemy_4()
        end
    end,
    restart = function()
        gameTimer = 0
    end
}
