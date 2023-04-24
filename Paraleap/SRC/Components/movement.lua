local Movement = {}

--------------------
-- create a movement component
--------------------

function Movement.new(spd)
    local self = setmetatable({}, {__index = Movement})
    
    self.mov = 0
    self.dir = 1
    self.spd = spd
    self.isWallJump  = false
    self.isWallSlide = false
    self.isPowerJump = false
    self.timer = {coyote = 0, jumpBuffer = 0, wallJump = 0}
    
    return self
end

--------------------
-- movement update
--------------------

-- consts variables
local acceleration        = 0.5
local slowDown            = 0.5
local slowDownInAir       = 0.2
local speedInAirMult      = 1.5
local jumpForce           = -8
local coyoteTime          = 0.2
local jumpBufferTime      = 0.15
local jumpAirReduce       = 0.4
local powerJumpForce      = -12
local powerJumpThreshold  = 0.5
local wallSlideSpeed      = 0.2
local wallJumpTime        = 0.2
local wallJumpForceNormal = {8, -8}
local wallJumpForcePower  = {12, -12}
local wallJumpGoingUpDamp = 0.025
local wallJumpFallingDamp = 0.05

-- linear interpolation
local function lerp(a, b, t)
    return a + (b - a) * t  
end

-- move towards
local function moveTowards(a, b, t)
    -- retorns the sign of number
    local function sign(x)
      return x == 0 and 0 or x/math.abs(x)
    end
    
    if math.abs(b - a) <= t then return b end
    return a + sign(b - a) * t
end

-- walk system
function Movement:walk(entity, t)
    -- local variables
    local velX, velY = entity.physics:getVelocity()
    local isGrounded = entity.collider:isColliding('ground')
    
    -- determine left or right movement
		local leftMove  = hud:down('left') and -1 or 0
		local rightMove = hud:down('right') and 1 or 0
		local movement  = leftMove + rightMove
		
    -- define movement direction
    if movement ~= 0 then self.dir = movement end
    
    -- increases speed if you are at the jump limit 
    local inAir = entity.physics:isJumpHang()
    local speed = inAir and self.spd * speedInAirMult or self.spd
    
    -- apply movement velocity
    if movement == 0 then
      -- slow down the speed 
      local damping = isGrounded and slowDown or slowDownInAir
      velX = moveTowards(velX, 0, damping * t)
    else
      -- accelerate the speed 
      local damping = acceleration
      if self.isWallJump then
        damping = velY < 0 and wallJumpGoingUpDamp or wallJumpFallingDamp
      end
      velX = lerp(velX, movement * speed, damping * t)
    end
    
    -- update state
    self.mov = movement
    entity.physics:setVelocity(velX, velY)
end

--------------------

-- jump system
function Movement:jump(entity, t)
    -- local variables
    local dt = love.timer.getDelta()
    local velX, velY  = entity.physics:getVelocity()
    local isGrounded  = entity.collider:isColliding('ground')
    local isPowerJump = self.isPowerJump
    
    -- coyote time
    local coyoteCount = coyoteTime
    if not isGrounded then
      coyoteCount = self.timer.coyote - dt
      coyoteCount = math.max(coyoteCount, 0)
    end
    
    -- jump buffer time
    local jumpBufferCount = jumpBufferTime
    if not hud:pressed('jump') then
      jumpBufferCount = self.timer.jumpBuffer - dt
      jumpBufferCount = math.max(jumpBufferCount, 0)
    end
    
    -- power jump
    if isGrounded or self.isWallJump then
      isPowerJump = false
    end
    
    -- make jump
    if jumpBufferCount > 0 and coyoteCount > 0 then
      -- when to jump
      velY = jumpForce
      jumpBufferCount = 0
    elseif hud:released('jump') then
      if velY < 0 then
        -- when you release the button and it's going up
        velY = velY * jumpAirReduce
      elseif isGrounded then
        -- when only when you release the button and you're on the ground
        velY = powerJumpForce
        isPowerJump = true
      end
      coyoteCount = 0
    end
    
    -- update state
    self.isPowerJump      = isPowerJump
    self.timer.coyote     = coyoteCount
    self.timer.jumpBuffer = jumpBufferCount
    entity.physics:setVelocity(velX, velY)
end

--------------------

-- slide system
function Movement:wallSlide(entity)
    -- local variables
    local isMoving   = self.mov ~= 0
    local velX, velY = entity.physics:getVelocity()
    local isGrounded = entity.collider:isColliding('ground')
    local isWalled   = entity.collider:isColliding('wall')
    
    -- if it's sliding on the wall
    local isWallSlide = false
    if isMoving and not isGrounded and isWalled then
      isWallSlide = true
      velY = math.min(velY, wallSlideSpeed)
    end
    
    -- update state
    self.isWallSlide = isWallSlide
    entity.physics:setVelocity(velX, velY)
end

--------------------

-- wall jump system
function Movement:wallJump(entity)
    -- update the wall slide system
    self:wallSlide(entity)
    
    -- local variables
    local dt = love.timer.getDelta()
    local isWallJump    = self.isWallJump
    local wallJumpCount = self.timer.wallJump

    -- if it's sliding on the wall
    if self.isWallSlide then
      isWallJump    = false
      wallJumpCount = wallJumpTime
    else
      wallJumpCount = wallJumpCount - dt
    end
    
    -- when you jump and you're sliding on the wall
    if hud:pressed('jump') and wallJumpCount > 0 then
      -- define wall jump direction 
      local wallJumpDir = -self.dir
      if not entity.collider:isColliding('wall') then
        wallJumpDir = -wallJumpDir
      end
      
      -- do a super wall jump
      if self.isPowerJump then
        entity.physics:setVelocity(wallJumpForcePower[1] * wallJumpDir, wallJumpForcePower[2])
      else
        entity.physics:setVelocity(wallJumpForceNormal[1] * wallJumpDir, wallJumpForceNormal[2])
      end
      
      isWallJump = true
      wallJumpCount = 0
    end
    
    -- deactivate the wall jump when colliding with the floor
    if entity.collider:isColliding('ground') then
      isWallJump = false
    end
    
    -- update states
    self.isWallJump     = isWallJump
    self.timer.wallJump = wallJumpCount
end

--------------------

function Movement:update(entity, t)
    self:walk(entity, t)
    self:jump(entity, t)
    self:wallJump(entity)
end

--------------------
-- return functions
--------------------

function Movement:getDirection()
    return self.dir  
end

--------------------

return Movement