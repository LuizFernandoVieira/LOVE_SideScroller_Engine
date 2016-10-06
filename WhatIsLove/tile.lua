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

--- Initializes tile.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
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
function Tile:isDead()
end

--- Notifies the tile that a collision involving himself had ocurred.
-- The tile (subject) had previously subscribed
-- to the collision system (observer).
-- @param other
function Tile:notifyCollision(other)
end

--- Specifies the type of that object.
-- @param type
-- @return boolean
function Tile:is(type)
  return type == self.type
end
