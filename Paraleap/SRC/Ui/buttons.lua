local button = {}
button.__index = button

--------------------
-- create a new button
--------------------

function button.new(id, x, y, sz, style)
    local self = setmetatable({}, button)
    
    self.id    = id
    self.x     = x
    self.y     = y
    self.sz    = sz
    self.down  = false
    self.last  = false
    self.style = {}
    self.style.noDown = style[1]
    self.style.isDown = style[2]
    self.style.show   = self.style.noDown
    
    return self
end

--------------------
-- update the buttons
--------------------

-- returns if the button is being pressed
local function buttonIsTouched(tx, ty, bx, by, bsz)
    local dx, dy = tx - bx, ty - by
    return math.sqrt(dx*dx + dy*dy) < bsz
end

function button:update()
    self.last = self.down
    self.down = false
		self.style.show = self.style.noDown
		local touches = love.touch.getTouches()
    for id = 1, #touches do
      local tx, ty = love.touch.getPosition(touches[id])
      if buttonIsTouched(tx, ty, self.x, self.y, self.sz) then
        self:enable()
      end
    end
end

--------------------
-- draw the buttons
--------------------

function button:draw()
		love.graphics.setColor(self.style.show)
		love.graphics.circle('fill', self.x, self.y, self.sz)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.printf(self.id, self.x - self.sz, self.y - self.sz/2, self.sz*2, 'center')
end

--------------------
-- others functions
--------------------

function button:enable()
    self.down = true
		self.style.show = self.style.isDown
end

--------------------

return button