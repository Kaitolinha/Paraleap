local hud = {}

--------------------
-- load hud
--------------------

function hud:load()
    -- fast function to create a new button
    local function createButton(id, x, y, sz, style)
      local button = require('Ui/buttons')
      local windowWidth, windowHeight = love.graphics.getDimensions()
      return button.new(id, x*windowWidth, y*windowHeight, sz*windowWidth, style)
    end
    
    -- buttons styles
    local styleButtons = {}
    styleButtons[1]    = {1, 1, 1, 0.5}
    styleButtons[2]    = {1, 1, 1, 0.3}
    
    -- all hud buttons
    local buttonSize   = 0.05
    self.buttons       = {}
    self.buttons.left  = createButton('left', 0.1, 0.9, buttonSize, styleButtons)
    self.buttons.right = createButton('right', 0.2, 0.9, buttonSize, styleButtons)
    self.buttons.jump  = createButton('jump', 0.9, 0.9, buttonSize, styleButtons)
end

--------------------
-- update hud
--------------------

function hud:update()
    for _, button in pairs(self.buttons) do
      button:update()
    end 
    
    -- keybord 
    if love.keyboard.isDown('left') then self.buttons.left:enable() end
    if love.keyboard.isDown('right') then self.buttons.right:enable() end
    if love.keyboard.isDown('space') then self.buttons.jump:enable() end
end

--------------------
-- draw hud
--------------------

function hud:draw()
    for _, button in pairs(self.buttons) do
      button:draw()
    end 
end

--------------------

-- returns if the button is being pressed
function hud:down(id)
		return self.buttons[id].down
end

-- returns if button is pressed
function hud:pressed(id)
    local button = self.buttons[id]
		return button.down and not button.last
end

-- returns if the button stops being pressed
function hud:released(id)
    local button = self.buttons[id]
		return not button.down and button.last
end

--------------------

return hud