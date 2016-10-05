Tile         = {}
Tile.__index = Tile

setmetatable(Tile, {
  __index = GameObject,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

---
--
-- @param x
-- @param y
function Tile:_init(x, y)
  GameActor:_init(x, y)

  self.type = "Tile"
  self.box  = Rect(x, y, 16, 16)
end

---
--
-- @param dt Time passed since last update
function Tile:update(dt)
end

---
--
function Tile:draw()
end

---
--
function Tile:drawDebug()
  local lg = love.graphics
  local x  = self.box.x
  local y  = self.box.y
  local w  = self.box.w
  local h  = self.box.h
  love.graphics.setColor(0, 255, 0, 50)
  love.graphics.rectangle("fill", x, y, w, h)
  love.graphics.setColor(0, 255, 0)
  love.graphics.rectangle("line", x, y, w , h)
  love.graphics.setColor(255, 255, 255)
end

---
--
function Item:isDead()
end

---
--
function Item:notifyCollision()
end

---
--
-- @param type
-- @return boolean
function Item:is(type)
  return type == self.type
end
