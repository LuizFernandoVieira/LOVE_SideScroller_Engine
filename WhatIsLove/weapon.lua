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

--- Initializes weapon.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
function Weapon:_init(x, y)
  Item:_init(x, y)

  self.type      = "Weapon"
  self.sprite    = Sprite:_init(WEAPON_IMAGE, 1, 1)
  self.box       = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.collected = false
end

---
--
-- @param dt Time passed since last update
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
function Weapon:isDead()
  if self.collected then
    return true
  end
  return false
end

--- Notifies the weapon that a collision involving himself had ocurred.
-- The weapon (subject) had previously subscribed
-- to the collision system (observer).
-- @param other
function Weapon:notifyCollision(other)
  if other.type == "Player" then
    self.collected = true
  end
end

--- Specifies the type of that object.
-- @param type
-- @return boolean
function Weapon:is(type)
  return type == self.type
end
