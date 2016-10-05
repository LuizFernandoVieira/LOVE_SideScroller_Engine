Bite         = {}
Bite.__index = Bite

setmetatable(Bite, {
  __index = GameObject,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

--- Initializes bite
-- Bite's are created every time a infected player tries to attack
-- @param x Position in the x axis that these object will be placed
-- @param y Position in the y axis that these object will be placed
-- @param w Width of the collision area of that bite
-- @param h Height of the collision area of that bite
function Bite:_init(x, y, w, h)
  GameObject:_init(x, y)

  self.type         = "Bite"
  self.box          = Rect(x, y, w, h)
end

--- Updates the bite object
-- Called once once each love.update
-- @param dt Time passed since last update
function Bite:update(dt)
end

---
--
function Bite:draw()
end

---
--
function Bite:drawDebug()
  local lg = love.graphics
  local x  = self.box.x
  local y  = self.box.y
  local w  = self.box.w
  local h  = self.box.h
  lg.setColor(255, 0, 255, 50)
  lg.rectangle("fill", x, y, w, h)
  lg.setColor(255, 0, 255)
  lg.rectangle("line", x, y, w, h)
  lg.setColor(255, 255, 255)
end

---
--
-- @return boolean
function Bite:isDead()
  return true
end

---
--
-- @param other
function Bite:notifyCollision(other)
end

---
--
-- @param type
-- @return boolean
function Bullet:is(type)
  return type == self.type
end
