local Transform = {}

--------------------
-- create a transform component
--------------------

function Transform.new(x, y, w, h)
    local self = setmetatable({}, {__index = Transform})
    
    self.x = x
    self.y = y
    self.width  = w
    self.height = h
    self.angle  = 0
    
    return self
end

--------------------
-- set functions
--------------------

function Transform:setX(x)
    self.x = x
end

function Transform:setY(y)
    self.y = y
end

function Transform:setPosition(x, y)
    self.x, self.y = x, y  
end

function Transform:setWidth(width)
    self.width = width
end

function Transform:setHeight(height)
    self.height = height
end

function Transform:setDimensions(width, height)
    self.width, self.height = width, height  
end

--------------------
-- return functions
--------------------

function Transform:getX()
    return self.x
end

function Transform:getY()
    return self.y
end

function Transform:getPosition()
    return self.x, self.y
end

function Transform:getWidth()
    return self.width 
end

function Transform:getHeight()
    return self.height
end

function Transform:getDimensions()
    return self.width, self.height
end

function Transform:getRect()
    return self.x, self.y, self.width, self.height
end

--------------------

return Transform