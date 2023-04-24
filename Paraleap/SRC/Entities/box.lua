local Box = {}

--------------------
-- create a box class
--------------------

function Box.new(x, y, w, h)
    -- load components
    local Transform = require('Components/transform')
    local Collider  = require('Components/collider')
    local Physics   = require('Components/physics')
    
    local self = setmetatable({}, {__index = Box})
    
    self.class = 'box'
    
    self.transform = Transform.new(x, y, w, h)
    self.collider  = Collider.new(self)
    self.physics   = Physics.new()
    
    return self
end

--------------------
-- box update
--------------------

function Box:update(t)
    -- update the physics system
    if self.collider:isColliding('ground') then
      self.physics:impulse(0, 0, t)
    end
    self.physics:update(self, t)
end

--------------------
-- box draw
--------------------

function Box:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('line', self.transform:getRect())
end

--------------------

return Box