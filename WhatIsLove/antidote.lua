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

local ANTIDOTE_TYPE  = "Antidote"
local ANTIDOTE_IMAGE = "img/antidote.png"

--- Initializes antidote.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
function Antidote:_init(x, y)
  Item:_init(x, y)

  self.type      = ANTIDOTE_TYPE
  self.sprite    = Sprite:_init(ANTIDOTE_IMAGE, 1, 1)
  self.box       = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.collected = false
end

--- Updates the antidote object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function Antidote:update(dt)
  self.sprite:update(dt)
end

--- Draws the antidote object.
-- Called once once each love.draw.
function Antidote:draw()
  self.sprite:draw(self.box.x, self.box.y, 0)
end

--- Draws the antidote outline and collision area.
-- Called once once each love.draw if debug parameter passed.
function Antidote:drawDebug()
  local lg = love.graphics
  local x  = self.box.x
  local y  = self.box.y
  local w  = self.box.w
  local h  = self.box.h
  lg.setColor(255, 0, 0, 50)
  lg.rectangle( "fill", x, y, w, h)
  lg.setColor(255, 0, 0)
  lg.rectangle("line", x, y, w, h)
  lg.setColor(255, 255, 255)
end

--- Checks if antidote has been collected.
-- Once the antidote has been collected it shoud be destroyed.
-- @return boolean
function Antidote:isDead()
  if self.collected then
    return true
  end
  return false
end

--- Notifies the antidote that a collision involving himself had ocurred.
-- The antidote (subject) had previously subscribed
-- to the collision system (observer).
-- @param other Object that collided with the antidote
function Antidote:notifyCollision(other)
  if other.type == "Player" then
    self.collected = true
  end
end

--- Specifies the type of that object.
-- @param type Type of that object
-- @return boolean
function Antidote:is(type)
  return type == self.type
end
