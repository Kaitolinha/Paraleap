local map = {}

--------------------
-- map load
--------------------

local tiledMap = {
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
}

--------------------

-- conts variables
local tileSize = 16
local tileColors = {
  {1, 1, 1, 1}, -- tile type 1
  {1, 1, 1, 0}, -- tile type 2
  {1, 1, 1, 1}, -- tile type 3
  {1, 0, 0, 1}  -- tile type 4
}

--------------------

function map:load()
    self.tile = {}
    
    -- loop to create the tiles based on the map data
    for row = 1, #tiledMap do
      for col = 1, #tiledMap[row] do
        local tileType = tiledMap[row][col]
        if tileType ~= 0 then
          
          -- create the tile
          local tile = {
            class = 'map',
            type  = tileType,
            x     = (col - 1) * tileSize,
            y     = (row - 1) * tileSize,
            w     = tileSize,
            h     = tileSize,
            color = tileColors[tileType]
          }
          
          -- store the tile in the table of tiles
          table.insert(self.tile, tile)
          world:add(tile, tile.x, tile.y, tile.w, tile.h)
        end
      end
    end
    
		local windowWidth, windowHeight = love.graphics.getDimensions() 
    local Box = require('Entities/box')
    self.boxes = {}
    for i = 1, 1 do
      self.boxes[i] = Box.new(windowWidth/3.5, windowHeight/4, tileSize*2, tileSize*2)
    end
end

--------------------
--------------------
-- map update

function map:update(t)
    for i = 1, #self.boxes do
      self.boxes[i]:update(t)
    end
end

--------------------
-- map draw
--------------------

local function drawTileMap(tiledMap, tileSize)
    for i = 1, #tiledMap do
      local tile = tiledMap[i]
      local tileType = tile.type
      
      -- draw tiles
      -- love.graphics.setColor(tile.color)
      love.graphics.setColor(1,1,1,0.2)
      love.graphics.rectangle('line', tile.x, tile.y, tileSize, tileSize)
      -- love.graphics.printf(i, tile.x, tile.y + tile.h/3, tile.w, 'center')
    end
end

function map:draw()
    drawTileMap(self.tile, tileSize)
    for i = 1, #self.boxes do
      self.boxes[i]:draw()
    end
end

--------------------

return map