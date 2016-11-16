Ladder         = {}
Ladder.__index = Ladder

setmetatable(Ladder, {
  __index = GameObject,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local LADDER_IMAGE = "img/ladder.png"

--- Initializes ladder.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
function Ladder:_init(x, y)
  GameObject:_init(x, y)

  self.type      = "Ladder"
  self.sprite    = Sprite(LADDER_IMAGE, 1, 1)
  self.box       = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
end

--- Updates the ladder object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function Ladder:update(dt)
  self.sprite:update(dt)
end

--- Draws the ladder object.
-- Called once once each love.draw.
function Ladder:draw()
  self.sprite:draw(self.box.x, self.box.y, 0)
end

--- Draws the ladder outline and collision area.
-- Called once once each love.draw if debug parameter passed.
function Ladder:drawDebug()
  local lg = love.graphics
  local x  = self.box.x
  local y  = self.box.y
  local w  = self.sprite:getWidth()
  local h  = self.sprite:getHeight()
  lg.setColor(0, 200, 255, 50)
  lg.rectangle("fill", x, y, w, h)
  lg.setColor(0, 200, 255)
  lg.rectangle("line", x, y, w, h)
  lg.setColor(255, 255, 255)
end

--- Checks if ladder has been collected.
-- Once the ladder has been collected it shoud be destroyed.
-- @return boolean
function Ladder:isDead()
  return false
end

--- Notifies the ladder that a collision involving himself had ocurred.
-- The ladder (subject) had previously subscribed
-- to the collision system (observer).
-- @param other
function Ladder:notifyCollision(other)
end

--- Specifies the type of that object.
-- @param type
-- @return boolean
function Ladder:is(type)
  return type == self.type
end
