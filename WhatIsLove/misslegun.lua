Misslegun         = {}
Misslegun.__index = Misslegun

setmetatable(Misslegun, {
  __index = Weapon,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local MISSLEGUN_IMAGE = "img/missil.png"

--- Initializes laser gun.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
function Misslegun:_init(x, y)
  Weapon:_init(x, y)

  self.type      = "Misslegun"
  self.sprite    = Sprite:_init(MISSLEGUN_IMAGE, 1, 1)
  self.box       = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.collected = false
end

--- Updates the laser gun object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function Misslegun:update(dt)
  self.sprite:update(dt)
end

--- Draws the laser gun object.
-- Called once once each love.draw.
function Misslegun:draw()
  self.sprite:draw(self.box.x, self.box.y, 0)
end

--- Draws the laser gun outline and collision area.
-- Called once once each love.draw if debug parameter passed.
function Misslegun:drawDebug()
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

--- Checks if laser gun has been collected.
-- Once the laser gun has been collected it shoud be destroyed.
-- @return boolean
function Misslegun:isDead()
  if self.collected then
    return true
  end
  return false
end

--- Notifies the laser gun that a collision involving himself had ocurred.
-- The lase gun (subject) had previously subscribed
-- to the collision system (observer).
-- @param other
function Misslegun:notifyCollision(other)
  if other.type == "Player" then
    self.collected = true
  end
end

--- Specifies the type of that object.
-- @param type
-- @return boolean
function Misslegun:is(type)
  return type == self.type
end
