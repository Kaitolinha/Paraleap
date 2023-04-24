local Collider = {}

--------------------
-- create a collider component
--------------------

function Collider.new(entity)
    local self = setmetatable({}, {__index = Collider})
    
    self.cols = {
      wall       = false,
      ground     = false,
      ceiling    = false,
      wallBox    = false,
      groundBox  = false,
      ceilingBox = false,
    }
    
    -- add a collider
    world:add(entity, entity.transform:getRect())
    
    return self
end

--------------------
-- collider update
--------------------

function Collider:update(entity, goalX, goalY)
    -- check and move the collider
    local actualX, actualY, cols, len = world:move(entity, goalX, goalY)
    entity.transform:setPosition(actualX, actualY)
    
    for col in pairs(self.cols) do
      self.cols[col] = false
    end
    
    for i = 1, len do
      local col = cols[i]
      if col.other.class == 'map' then
        if col.normal.x ~= 0 then
          self.cols.wall = true
        end
        if col.normal.y == -1 then
          self.cols.ground = true
        end
        if col.normal.y == 1 then
          self.cols.ceiling = true
        end
      elseif col.other.class == 'box' then
        if col.normal.x ~= 0 then
          self.cols.wallBox = true
        end
        if col.normal.y == -1 then
          self.cols.groundBox = true
        end
        if col.normal.y == 1 then
          self.cols.ceilingBox = true
        end
      end
    end
    
    return actualX, actualY
end

--------------------
-- return functions
--------------------

function Collider:isColliding(col)
    return self.cols[col]
end

--------------------

return Collider