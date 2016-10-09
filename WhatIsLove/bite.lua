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

local BITE_IMAGE = "img/Bite.png"

--- Initializes a bite.
-- Bite's are created every time a infected player tries to attack.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
-- @param w Width of the collision area of that bite
-- @param h Height of the collision area of that bite
function Bite:_init(x, y, w, h)
  GameObject:_init(x, y)

  self.type         = "Bite"
  self.sprite       = Sprite:_init(BITE_IMAGE, 3, 0)
  self.box          = Rect(x, y, w, h)
end

--- Updates the bite object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function Bite:update(dt)
  self.sprite:update(dt)
end

--- Draws the antidote object.
-- Called once once each love.draw.
function Bite:draw()
  self.sprite:draw(self.box.x, self.box.y)
end

--- Draws the bite outline and collision area.
-- Called once once each love.draw if debug parameter passed.
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

--- Bite is killed after instantiate.
-- @return boolean
function Bite:isDead()
  return true
end

--- Notifies the bite that a collision involving himself had ocurred.
-- The antidote (subject) had previously subscribed
-- to the collision system (observer).
-- @param other Object that collided with the bite
function Bite:notifyCollision(other)
end

--- Specifies the type of that object.
-- @param type
-- @return boolean
function Bullet:is(type)
  return type == self.type
end
