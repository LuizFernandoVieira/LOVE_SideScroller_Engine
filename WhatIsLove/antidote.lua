Antidote         = {}
Antidote.__index = Antidote

setmetatable(Antidote, {
  __index = Item,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local ANTIDOTE_IMAGE = "img/misc/spr_cannondown_0.png"

---
-- 
function Antidote:_init(x, y)
  Item:_init(x, y)

  self.type      = "Antidote"
  self.sprite    = Sprite:_init(ANTIDOTE_IMAGE, 1, 1)
  self.box       = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.collected = false
end

---
--
function Antidote:update(dt)
  self.sprite:update(dt)
end

---
--
function Antidote:draw()
  self.sprite:draw(self.box.x, self.box.y, 0)
end

---
--
function Antidote:drawDebug()
  love.graphics.setColor(255, 0, 0, 50)
  love.graphics.rectangle(
    "fill",
    self.box.x,
    self.box.y,
    16, 16
  )
  love.graphics.setColor(255, 0, 0)
  love.graphics.rectangle(
    "line",
    self.box.x,
    self.box.y,
    16, 16
  )
  love.graphics.setColor(255, 255, 255)
end

---
--
function Antidote:isDead()
  if self.collected then
    return true
  end
  return false
end

---
--
function Antidote:notifyCollision(other)
  if other.type == "Player" then
    self.collected = true
  end
end

---
--
function Antidote:is(type)
  return type == self.type
end
