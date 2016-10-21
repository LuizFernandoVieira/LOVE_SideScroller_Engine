Shotgun         = {}
Shotgun.__index = Shotgun

setmetatable(Shotgun, {
  __index = Weapon,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local SHOTGUN_IMAGE = "img/machinegune.png"

--- Initializes shotgun.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
function Shotgun:_init(x, y)
  Weapon:_init(x, y)

  self.type      = "Shotgun"
  self.sprite    = Sprite:_init(SHOTGUN_IMAGE, 1, 1)
  self.box       = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.collected = false
end

--- Updates the shotgun object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function Shotgun:update(dt)
  self.sprite:update(dt)
end

--- Draws the shotgun object.
-- Called once once each love.draw.
function Shotgun:draw()
  self.sprite:draw(self.box.x, self.box.y, 0)
end

--- Draws the shotgun outline and collision area.
-- Called once once each love.draw if debug parameter passed.
function Shotgun:drawDebug()
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

--- Checks if shotgun has been collected.
-- Once the shotgun has been collected it shoud be destroyed.
-- @return boolean
function Shotgun:isDead()
  if self.collected then
    return true
  end
  return false
end

--- Notifies the shotgun that a collision involving himself had ocurred.
-- The shotgun (subject) had previously subscribed
-- to the collision system (observer).
-- @param other
function Shotgun:notifyCollision(other)
  if other.type == "Player" then
    self.collected = true
  end
end

--- Specifies the type of that object.
-- @return boolean
-- @param type
function Shotgun:is(type)
  return type == self.type
end
