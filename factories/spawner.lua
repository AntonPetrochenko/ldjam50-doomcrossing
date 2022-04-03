local enemy_factory = require 'factories.bird_enemy'

local left_border = -140
local right_border = 600

return {
    update = function()
        if love.keyboard.isDown('9') then
            world:add(enemy_factory())
        end
    end,

    fuck = '2423',

    asdasd = function()

    end
}