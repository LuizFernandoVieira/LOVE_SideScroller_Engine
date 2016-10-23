Bomb         = {}
Bomb.__index = Bomb

setmetatable(Bomb, {
  __index = GameObject,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local BOMB_IMAGE   = "img/EnemyFox-o-copter_bullet.png"
local BOMB_GRAVITY = 800

--- Initializes a bullet.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
-- @param speed Quantity that represents how fast this bullet moves
-- @param distanceLeft Amount of space left before the bullet is destroyed
function Bomb:_init(x, y, speed, distanceLeft)
  GameObject:_init(x, y)

  self.type          = "Bomb"
  self.sprite        = Sprite:_init(BOMB_IMAGE, 2, 0.5)
  self.box           = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.grounded      = false
  self.yspeed        = 0
  self.timeToExplode = 5
end

--- Updates the bullet object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function Bomb:update(dt)
  self.sprite:update(dt)

  if not self.grounded then
    self.yspeed = self.yspeed + BOMB_GRAVITY * dt
    self.box.y = self.box.y + self.yspeed * dt
  end

  self.timeToExplode =  self.timeToExplode - dt
end

--- Draws the bullet object.
-- Called once once each love.draw.
function Bomb:draw()
  self.sprite:draw(self.box.x, self.box.y, 0)
end

--- Draws the bite outline and collision area.
-- Called once once each love.draw if debug parameter passed.
function Bomb:drawDebug()
  local lg = love.graphics
  local x  = self.box.x + self.sprite:getWidth()/2
  local y  = self.box.y
  local w  = self.box.w
  local h  = self.box.h
  lg.setColor(0, 200, 255, 50)
  lg.rectangle("fill", x, y, w, h)
  lg.setColor(0, 200, 255)
  lg.rectangle("line", x, y, w, h)
  lg.setColor(255, 255, 255)
end

--- Checks if the bullet have traveled its full distance.
-- If so it should be destroyed.
-- @return boolean
function Bomb:isDead()
  if self.timeToExplode <= 0 then
    table.insert(missleBullets, MissleExplosion(self.box.x, self.box.y))
    return true
  else
    return false
  end
end

--- Notifies the bite that a collision involving himself had ocurred.
-- The bullet (subject) had previously subscribed
-- to the collision system (observer).
-- @param other
function Bomb:notifyCollision(other)
  if other.type == "Tile" then
    self.grounded = true
    self.yspeed = 0
  end
end

--- Specifies the type of that object.
-- @param type
-- @return boolean
function Bomb:is(type)
  return type == self.type
end
