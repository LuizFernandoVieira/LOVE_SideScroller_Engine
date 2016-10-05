Map         = {}
Map.__index = Map

---
--
function Map:_init()
    local self = setmetatable({}, Map)

    local file          = love.filesystem.load("maps/test_map.lua")()
    local x             = file.x
    local y             = file.y
    local width         = file.width
    local height        = file.height
    local tileSize      = file.tileSize
    local tileDiversity = file.tileDiversity
    local tileset       = love.graphics.newImage(file.tileset.image)
    local data          = file.data

    tileset:setFilter("nearest", "nearest")

    tileQuads = {}
    for j=0, 1-1 do
      for i=0, tileDiversity-1 do
        tileQuads[i+(j*5)] = love.graphics.newQuad(
          i * tileSize,
          j * tileSize,
          tileSize,
          tileSize,
          tileset:getWidth(),
          tileset:getHeight()
        )
      end
    end

    for j=0, height-1 do
      for i=0, width-1 do
        if data[j+y][i+x] == 01 then
          table.insert(tiles, Tile(i * tileSize, j * tileSize))
        end
      end
    end

    tilesetBatch = love.graphics.newSpriteBatch(tileset, width * height)
    tilesetBatch:clear()

    for j=0, height-1 do
      for i=0, width-1 do
        tilesetBatch:add(tileQuads[data[j+y][i+x]], i*tileSize, j*tileSize)
      end
    end
    tilesetBatch:flush()
end

---
--
function Map:update(dt)
end

---
-- 
function Map:draw()
end
