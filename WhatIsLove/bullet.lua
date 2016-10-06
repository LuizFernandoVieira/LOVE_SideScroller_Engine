Bullet         = {}
Bullet.__index = Bullet

setmetatable(Bullet, {
  __index = GameObject,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local BULLET_IMAGE = "img/tiro.png"

--- Initializes a bullet.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
-- @param speed Quantity that represents how fast this bullet moves
-- @param distanceLeft Amount of space left before the bullet is destroyed
function Bullet:_init(x, y, speed, distanceLeft)
  GameObject:_init(x, y)

  self.type         = "Bullet"
  self.sprite       = Sprite:_init(BULLET_IMAGE, 1, 1)
  self.speedX       = speed
  self.distanceLeft = distanceLeft
  self.box          = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
end

--- Updates the bullet object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function Bullet:update(dt)
  self.sprite:update(dt)

  local previousX   = self.box.x
  self.box.x        = self.box.x + self.speedX * dt;
  self.distanceLeft = self.distanceLeft - math.abs(previousX)
end

--- Draws the bullet object.
-- Called once once each love.draw.
function Bullet:draw()
  self.sprite:draw(self.box.x, self.box.y, 0)
end

--- Draws the bite outline and collision area.
-- Called once once each love.draw if debug parameter passed.
function Bullet:drawDebug()
  local lg = love.graphics
  local x  = self.box.x
  local y  = self.box.y
  local w  = self.box.w
  local h  = self.box.h
  lg.setColor(255, 255, 0, 50)
  lg.rectangle("fill", x, y, w, h)
  lg.setColor(255, 255, 0)
  lg.rectangle("line", x, y, w, h)
  lg.setColor(255, 255, 255)
end

--- Checks if the bullet have traveled its full distance.
-- If so it should be destroyed.
-- @return boolean
function Bullet:isDead()
  if distanceLeft > 0 then
    return false
  else
    return true
  end
end

--- Notifies the bite that a collision involving himself had ocurred.
-- The bullet (subject) had previously subscribed
-- to the collision system (observer).
-- @param other
function Bullet:notifyCollision(other)
  if other.type == "Enemy" then
    for k,v in ipairs(bullets) do
      if v.id == other.id then
        bullets[k] = nil
      end
    end
  end
end

--- Specifies the type of that object.
-- @param type
-- @return boolean
function Bullet:is(type)
  return type == self.type
end
