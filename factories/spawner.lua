local left_border = -160
local right_border = 620
local bottom_border = 180

local enemy_1_spawnTimer = 0
local enemy_1_spawnDuration = 1
local enemy_factory = require 'factories.bird_enemy'

local function spawn_enemy_1()
    world:add(enemy_factory(math.random(left_border, right_border), bottom_border))
end

return {
    update = function(dt)
        enemy_1_spawnTimer = enemy_1_spawnTimer + dt
        if enemy_1_spawnTimer > enemy_1_spawnDuration then
            enemy_1_spawnTimer = enemy_1_spawnTimer - enemy_1_spawnDuration

            spawn_enemy_1()
        end

        if love.keyboard.isDown('9') then
            spawn_enemy_1()
        end
    end,
    restart = function()
        
    end,

    fuck = '2423',

    asdasd = function()

    end
}