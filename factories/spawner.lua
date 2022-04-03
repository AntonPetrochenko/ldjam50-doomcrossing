local player_xy_enemy_factory = require 'factories.player_xy_enemy'
local random_xy_enemy_factory = require 'factories.random_xy_enemy'
local shooting_enemy_factory = require 'factories.shooting_enemy'

local left_border = -140
local right_border = 600

return {
    update = function()
        if love.keyboard.isDown('9') then
            world:add(shooting_enemy_factory(100,100))
        end
    end,

    fuck = '2423',

    asdasd = function()

    end
}