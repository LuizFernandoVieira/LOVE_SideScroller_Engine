Gun         = {}
Gun.__index = Gun

setmetatable(Gun, {
  __index = Weapon,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local GUN_IMAGE = "img/misc/spr_smoke_2.png"

---
--
function Gun:_init(x, y)
  Weapon:_init(x, y)

  self.type      = "Gun"
  self.sprite    = Sprite:_init(GUN_IMAGE, 1, 1)
  self.box       = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.collected = false
end

---
--
function Gun:update(dt)
  self.sprite:update(dt)
end

---
--
function Gun:draw()
  self.sprite:draw(self.box.x, self.box.y, 0)
end

---
--
function Gun:drawDebug()
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
function Gun:isDead()
  if self.collected then
    return true
  end
  return false
end

---
--
function Gun:notifyCollision(other)
  if other.type == "Player" then
    self.collected = true
  end
end

---
-- 
function Gun:is(type)
  return type == self.type
end
