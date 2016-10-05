Weapon         = {}
Weapon.__index = Weapon

setmetatable(Weapon, {
  __index = Item,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local WEAPON_IMAGE = "img/misc/spr_smoke_2.png"

---
--
function Weapon:_init(x, y)
  Item:_init(x, y)

  self.type      = "Weapon"
  self.sprite    = Sprite:_init(WEAPON_IMAGE, 1, 1)
  self.box       = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.collected = false
end

---
--
function Weapon:update(dt)
  self.sprite:update(dt)
end

---
--
function Weapon:draw()
  self.sprite:draw(self.box.x, self.box.y, 0)
end

---
--
function Weapon:drawDebug()
  love.graphics.setColor(255, 0, 0, 50)
  love.graphics.rectangle(
    "fill",
    self.box.x,
    self.box.y,
    self.box.w,
    self.box.h
  )
  love.graphics.setColor(255, 0, 0)
  love.graphics.rectangle(
    "line",
    self.box.x,
    self.box.y,
    self.box.w,
    self.box.h
  )
  love.graphics.setColor(255, 255, 255)
end

---
--
function Weapon:isDead()
  if self.collected then
    return true
  end
  return false
end

---
--
function Weapon:notifyCollision(other)
  if other.type == "Player" then
    self.collected = true
  end
end

---
-- 
function Weapon:is(type)
  return type == self.type
end
