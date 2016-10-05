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
-- @param x
-- @param y
function Item:_init(x, y)
  GameObject:_init(x, y)

  self.type      = "Item"
  self.sprite    = Sprite:_init(ITEM_IMAGE, 1, 1)
  self.box       = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.collected = false
end

---
--
-- @param dt Time passed since last update
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
  local lg = love.graphics
  local x  = self.box.x
  local y  = self.box.y
  local w  = self.box.w
  local h  = self.box.h
  lg.setColor(255, 0, 0, 50)
  lg.rectangle("fill", x, y, w, h)
  lg.setColor(255, 0, 0)
  lg.rectangle("line", x, y, w, h)
  lg.setColor(255, 255, 255)
end

---
--
-- @return boolean
function Item:isDead()
  if self.collected then
    return true
  end
  return false
end

---
--
-- @param other
function Item:notifyCollision(other)
  if other.type == "Player" then
    self.collected = true
  end
end

---
--
-- @param type
-- @return boolean
function Item:is(type)
  return type == self.type
end
