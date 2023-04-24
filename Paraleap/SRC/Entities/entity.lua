local Entity = {}

--------------------
-- create entity class
--------------------

function Entity.new(id, x, y, w, h, spd)
    local self = setmetatable({}, {__index = Entity})
    self.class = 'entity'
    self.id = id
    
    -- load components
    local Transform = require('Components/transform')
    local Collider  = require('Components/collider')
    local Physics   = require('Components/physics')
    local Movemennt = require('Components/movement')
    
    self.transform = Transform.new(x, y, w, h)
    self.collider  = Collider.new(self)
    self.physics   = Physics.new()
    self.movement  = Movemennt.new(spd)
    
    return self
end

--------------------
-- entity update
--------------------

function Entity:update(t)
    -- update the physics system
    self.physics:update(self, t)
    -- update the movement system
    self.movement:update(self, t)
end

--------------------
-- entity draw
--------------------

function Entity:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle('line', self.transform:getRect())
end

--------------------

return Entity