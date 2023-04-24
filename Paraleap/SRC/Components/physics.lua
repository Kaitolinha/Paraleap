local Physics = {}

--------------------
-- create a physics component
--------------------

function Physics.new(spd)
    local self = setmetatable({}, {__index = Physics})
    
    self.vx = 0
    self.vy = 0
    self.jumpHang = false
    
    return self
end

--------------------
-- physics update
--------------------

-- consts variables
local gravityForce       = 0.4
local maxGravityFall     = 25
local powerJumpGravity   = 2
local jumpHangThreshold  = 0.1
local jumpHangGravReduce = 0.2

-- gravity system
function Physics:gravity(entity, t)
    -- local variables
    local velX, velY = self:getVelocity()
    local isGrounded = entity.collider:isColliding('ground')
    
    -- reduce gravity when in air to simulate air resistance
    local inAir   = math.abs(velY) < jumpHangThreshold and not isGrounded
    local gravity = inAir and gravityForce * jumpHangGravReduce or gravityForce
    
    -- put pressure down if jump button is pressed 
    if hud:down('jump') and velY > jumpHangThreshold then
      gravity = gravityForce * powerJumpGravity
    end
    
    -- set gravity and set fall speed limit
    if velY < maxGravityFall then
      self:impulse(0, gravity, t)
    end
    
    -- update state
    self.jumpHang = inAir
end

--------------------

function Physics:move(entity, dx, dy, t)
    -- move, checking for collisions
    local posX, posY = entity.transform:getPosition()
    local goalX = posX + dx * t
    local goalY = posY + dy * t
    entity.collider:update(entity, goalX, goalY)
    
    -- check for collisions
    local velX, velY = self:getVelocity()
    local cols = entity.collider
    if cols:isColliding('wall') or cols:isColliding('wallBox') then velX = 0 end
    if cols:isColliding('ceiling') or cols:isColliding('ceilingBox') then velY = 0 end
    if cols:isColliding('ground') or cols:isColliding('groundBox') then velY = 0 end
    
    -- update states
    self:setVelocity(velX, velY)
end

--------------------

function Physics:update(entity, t)
    self:gravity(entity, t)
    self:move(entity, self.vx, self.vy, t)
end

--------------------
-- set functions
--------------------

function Physics:setVelocity(vx, vy)
    self.vx, self.vy = vx, vy
end

function Physics:impulse(fx, fy, t)
    self.vx = self.vx + fx * t
    self.vy = self.vy + fy * t
end

--------------------
-- return functions
--------------------

function Physics:getVelocity()
    return self.vx, self.vy
end

function Physics:isJumpHang()
    return self.jumpHang  
end

--------------------

return Physics