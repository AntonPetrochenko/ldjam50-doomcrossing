local bump = require 'bump'

local physicsWorld = bump.newWorld()

local world = {
    objects = {},
    physicsWorld = physicsWorld,
    update = function(self,dt) 
        for i,v in pairs(self.objects) do
            v:update(dt)
        end
    end,
    draw = function(self,dt)
        table.sort(self.objects, function (left, right)
            return left.y < right.y
        end)
        for i,v in pairs(self.objects) do
            v:draw(dt)
        end
    end,
    add = function(self,new)
        local o = self.objects
        local newid = love.math.random(999999999)

        if new.collides then {
            physicsWorld.add(new, new.x, new.y, new.pw, new.ph)

            new.touching = function (target_type)
                physicsWorld:queryRect(new.x-1,new.y-1,new.pw+2,new.ph+2, function (item) {
                    local notme = item.myid != newid
                    local istype = item.collision_type == target_type
                })
            end

            new.finalize_motion = function (x,y)
                local actualX, actualY = physicsWorld:move(new, new.x, new.y, function (item, other) 
                    other:on_collision(item)
                    return 'touch' 
                end )
                new.x, new.y = actualX, actualY
            end
        }
        


        o[#o+1] = new
        new.myid = newid
    end,
    del = function(self,old) 
        local o = self.objects
        local todelete = nil
        for i,v in pairs(o) do
            if v.myid == old.myid then
                todelete = i
            end
        end
        if o[todelete] then
            table.remove(o,todelete)
        else
            print("Deleting nonexistant object",todelete)
        end
    end
}
return world