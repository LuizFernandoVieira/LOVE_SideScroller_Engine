Machinegun         = {}
Machinegun.__index = Machinegun

setmetatable(Machinegun, {
  __index = Weapon,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local MACHINEGUN_IMAGE = "img/Tiro.png"

--- Initializes shotgun.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
function Machinegun:_init(x, y)
  Weapon:_init(x, y)

  self.type      = "Machinegun"
  self.sprite    = Sprite:_init(MACHINEGUN_IMAGE, 1, 1)
  self.box       = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.collected = false
end

--- Updates the shotgun object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function Machinegun:update(dt)
  self.sprite:update(dt)
end

--- Draws the shotgun object.
-- Called once once each love.draw.
function Machinegun:draw()
  self.sprite:draw(self.box.x, self.box.y, 0)
end

--- Draws the shotgun outline and collision area.
-- Called once once each love.draw if debug parameter passed.
function Machinegun:drawDebug()
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
function Machinegun:isDead()
  if self.collected then
    return true
  end
  return false
end

--- Notifies the shotgun that a collision involving himself had ocurred.
-- The shotgun (subject) had previously subscribed
-- to the collision system (observer).
-- @param other
function Machinegun:notifyCollision(other)
  if other.type == "Player" then
    self.collected = true
  end
end

--- Specifies the type of that object.
-- @return boolean
-- @param type
function Machinegun:is(type)
  return type == self.type
end
