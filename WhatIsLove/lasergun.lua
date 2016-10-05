Lasergun         = {}
Lasergun.__index = Lasergun

setmetatable(Lasergun, {
  __index = Weapon,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local LASERGUN_IMAGE = "img/misc/spr_smoke_4.png"

---
--
-- @param x
-- @param y
function Lasergun:_init(x, y)
  Weapon:_init(x, y)

  self.type      = "Lasergun"
  self.sprite    = Sprite:_init(LASERGUN_IMAGE, 1, 1)
  self.box       = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.collected = false
end

---
--
-- @param dt Time passed since last update
function Lasergun:update(dt)
  self.sprite:update(dt)
end

---
--
function Lasergun:draw()
  self.sprite:draw(self.box.x, self.box.y, 0)
end

---
--
function Lasergun:drawDebug()
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
function Lasergun:isDead()
  if self.collected then
    return true
  end
  return false
end

---
--
-- @param other
function Lasergun:notifyCollision(other)
  if other.type == "Player" then
    self.collected = true
  end
end

---
--
-- @param type
-- @return boolean
function Lasergun:is(type)
  return type == self.type
end
