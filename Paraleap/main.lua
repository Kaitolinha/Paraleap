function love.load()
    love.filesystem.setRequirePath("Paraleap/SRC/?.lua;")
		local windowWidth, windowHeight = love.graphics.getDimensions() 
		
		local bump = require('Libraries/bump')
    world = bump.newWorld(128)
    
		hud = require('Ui/hud')
		hud:load()
		
		map = require('Map/map')
		map:load()
		
		local classEntity = require('Entities/entity')
	 	player = classEntity.new('player', windowWidth/4, windowHeight/4, 16, 16, 5)
end

--------------------

function love.update(dt)
    local t = dt*60
    hud:update()
    map:update(t)
    player:update(t)
end

-------------------

local function drawDebug(table, x, y)
  local i = 1
  for key, value in pairs(table) do
    if type(value) == 'table' then
      if type(key) == 'number' then else
        love.graphics.print(key..':', x, 20+y*i)
      end
      drawDebug(value, x+75, 15+y*i)
      i = i + 5
    else
      love.graphics.print(key .. ": " .. tostring(value), x, y+15*i)
      i = i + 1
    end
  end
end

function love.draw()
    love.graphics.push()
      love.graphics.scale(2)
      map:draw()
      player:draw()
    love.graphics.pop()
    hud:draw()
    
    love.graphics.setColor(1,1,1,1)
		local windowWidth, windowHeight = love.graphics.getDimensions()
		love.graphics.print('fps: '..love.timer.getFPS()..'\nram: '..math.floor(collectgarbage("count")/100)/10 ..' mb', windowWidth*0.9, 15)
    -- local player = {table1={2, 4, obj = {8, 3, 7}}}
    -- local player = {table1={2, 4, obj = {8, 3, 7}}, table2 = {5, 7, obj2 = {2, 4, 9}}, table3 ={2, 4, obj3 = {8, 3, 7}}}
    -- local i = 1
    -- for k, v in pairs(player) do
    --   if type(v) == 'table' then
    --     drawDebug(v, 150*i, 30)
    --     i = i + 1
    --   end
    -- end
love.graphics.push()
      love.graphics.scale(0.7)
    drawDebug(player, 0, 30)
love.graphics.pop()
--[[
    drawDebug(player.transform, 0, 30)
    drawDebug(player.physics, 150, 30)
    drawDebug(player.collider, 150*2, 30)
    drawDebug(player.movement, 150*3, 30)
    ]]
end