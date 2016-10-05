Item         = {}
Item.__index = Item

setmetatable(Item, {
  __index = GameObject,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local ITEM_IMAGE = "img/misc/spr_star_0.png"

---
--
function Item:_init(x, y)
  GameObject:_init(x, y)

  self.type      = "Item"
  self.sprite    = Sprite:_init(ITEM_IMAGE, 1, 1)
  self.box       = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.collected = false
end

---
--
function Item:update(dt)
  self.sprite:update(dt)
end

---
--
function Item:draw()
  self.sprite:draw(self.box.x, self.box.y, 0)
end

---
--
function Item:drawDebug()
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
function Item:isDead()
  if self.collected then
    return true
  end
  return false
end

---
--
function Item:notifyCollision(other)
  if other.type == "Player" then
    self.collected = true
  end
end

---
-- 
function Item:is(type)
  return type == self.type
end
