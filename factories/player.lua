local bullet = require 'factories.bullet'
local rumbler = require 'rumbler'

return function (joyrecord,x,y)
    local player = {}

    print(love.filesystem.getWorkingDirectory())

    player.team = 0
    player.joy = joyrecord.instance
    player.inputbuffer = {}
    player.x = x
    player.y = y
    player.z = 0
    
    player.shoot_x = 24/2
    player.shoot_y = 32/2

    player.collides = true
    player.pw = 24
    player.ph = 32

    player.fire_timer = -0.1

    player.health = 3
    player.stamina = 3
    player.inactivity = 0
    player.score = 0

    player.weapon = {
        impulse = 7,
        damping = 1,
        cut = 0.2,

        spread = 1,
        spray = 0.1,

        number = 0,
        damage = 1,

        rate = 0.3,
        rumble_strength = 0.5,
        rumble_duration = 0.1
    }

    player.on_collision = function (self, other)
        print('collision happening')
    end

    player.isplayer = true

    

    player.hitbox = hitbox.new(0, 0, 0, 24, 32, 5, function (attacker,hitv)
        player.knockvx = hitv[1]
        player.knockvz = hitv[3]
        player.stamina = player.stamina - 1
        
        if hitv[3] > 10 then
            player.stamina = -1
            
        end
        player.hitbox.enabled = false
        if player.stamina > 0 then
            player:setstate("hit1")
        else
            attacker.score = attacker.score + 1
            player:setstate("knockover")
        end
    
    end)
    

    player.statetimer = 0

    player.left = false

    player.update_states = sharedstates.create_update_states()
    player.draw_states = sharedstates.create_draw_states()

    local function walk_movement(self, dt)
        local ax1, ax2, ax3, ax4, ax5, ax6 = self.joy:getAxes()
        if math.abs(ax1) < 0.2 then ax1 = 0 end
        if math.abs(ax2) < 0.2 then ax2 = 0 end

        if ax1 < -0.1 then player.left = true  end
        if ax1 >  0.1 then player.left = false end

        self.x = self.x + ((ax1)*dt)*70
        self.y = self.y + ((ax2/2)*dt)*50

        if math.abs(ax1) > 0.2 then
            self.inactivity = 0
        end

        self.finalize_motion()
    end

    local function aim_and_shoot(self, dt)
        local ax1, ax2, ax3, ax4, ax5, ax6 = self.joy:getAxes()

        player.fire_timer = player.fire_timer + dt
        if player.fire_timer > 0 then
            if ax6 > -0.5 then
                player.fire_timer = -self.weapon.rate

                for i=0,self.weapon.number do 
                    local target_x = self.x + ax4
                    local target_y = self.y + ax5

                    local self_x = self.x
                    local self_y = self.y

                    local aim_angle = math.atan2(target_y-self_y,target_x-self_x)
                    local spread_angle = aim_angle + (math.random()-0.5)*self.weapon.spray
                    local spread_velocity = self.weapon.impulse - math.random()*self.weapon.spread


                    world:add(bullet(self.x+self.shoot_x, self.y+self.shoot_y, spread_velocity, self.weapon.damping, spread_angle, self.weapon.cut))
                end
                rumbler.run(self.team, self.weapon.rumble_strength, self.weapon.rumble_duration)
            end
        end

    end

    -- state normal
    function player.update_states.normal(self, dt)
        self.inactivity = self.inactivity + dt
        walk_movement(self, dt)
        aim_and_shoot(self, dt)

        if self.joy:isGamepadDown("leftshoulder", "rightshoulder") then
            self.hitbox.enabled = false
            self:setstate("block")
        end
    end
    
    function player.draw_states.normal(self,dx,dy,dz,f,ox)
        local ax1, ax2 = self.joy:getAxes()
        if math.abs(ax1) > 0.2 or math.abs(ax2) > 0.2 then
            if self.statetimer % 0.4 < 0.2 then love.graphics.draw(self.frames.walk1,dx,dy - dz,nil,f,1,ox)
            else love.graphics.draw(self.frames.walk2,dx,dy - dz,nil,f,1,ox) end
        else
            love.graphics.draw(self.frames.idle,dx,dy - dz,nil,f,1,ox)
        end

        
    end


    function player.setstate(self, newstate)
        self.statetimer = 0
        self.inactivity = 0
        if self.update_states[newstate] then 
            print("CHANGIN STATE!!11 " .. newstate)
            self.current_update_state = self.update_states[newstate]
            self.current_draw_state = self.draw_states[newstate]
        else 
            print("BAD STATAE " .. newstate)
        end
    end

    player:setstate("normal")

    function player.update(self,dt)
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
        self:current_update_state(dt)
        self.statetimer = self.statetimer + dt
        self.z = self.z - dt * 10
        if self.z < 0 then self.z = 0 end
    end

    function player.draw(self)
        local dx, dy, dz = math.floor(self.x), math.floor(self.y), math.floor(self.z)
        local f = self.left and -1 or 1
        local ox = self.left and 24 or 0
        if self.z > 3 then
            love.graphics.setColor(0,0,0,0.5)
            love.graphics.ellipse("fill",self.x+12,self.y+32,8,4)
            love.graphics.setColor(1,1,1,1)
        end 
        self:current_draw_state(dx,dy,dz,f,ox)
    end
    return player
end