BlobEnemyBullet         = {}
BlobEnemyBullet.__index = BlobEnemyBullet

setmetatable(BlobEnemyBullet, {
  __index = GameObject,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local BULLET_DOWN_IMAGE = "img/EnemyDriper_bulletDown.png"
local BULLET_UP_IMAGE   = "img/EnemyDriper_bulletUp.png"

--- Initializes a bullet.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
-- @param speed Quantity that represents how fast this bullet moves
-- @param distanceLeft Amount of space left before the bullet is destroyed
function BlobEnemyBullet:_init(x, y, dir, distanceLeft)
  GameObject:_init(x, y)

  self.type = "BlobEnemiesBullet"

  if dir == nil or dir == "down" then
    self.sprite = Sprite(BULLET_DOWN_IMAGE, 1, 1)
    self.speedY = 60
  else
    self.sprite = Sprite(BULLET_UP_IMAGE, 1, 1)
    self.speedY = -60
  end

  self.distanceLeft = distanceLeft
  self.box          = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
end

--- Updates the bullet object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function BlobEnemyBullet:update(dt)
  self.sprite:update(dt)

  local previousY   = self.box.y
  self.box.y        = self.box.y + self.speedY * dt

  self.distanceLeft = self.distanceLeft - (self.box.y - previousY)
end

--- Draws the bullet object.
-- Called once once each love.draw.
function BlobEnemyBullet:draw()
  self.sprite:draw(self.box.x, self.box.y, 0)
end

--- Draws the bite outline and collision area.
-- Called once once each love.draw if debug parameter passed.
function BlobEnemyBullet:drawDebug()
  local lg = love.graphics
  local x  = self.box.x
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
function BlobEnemyBullet:isDead()
  if self.distanceLeft > 0 then
    return false
  else
    return true
  end
end

--- Notifies the bite that a collision involving himself had ocurred.
-- The bullet (subject) had previously subscribed
-- to the collision system (observer).
-- @param other
function BlobEnemyBullet:notifyCollision(other)
  if other.type == "Player" then
    for k,v in ipairs(defShotEnemiesBullets) do
      if v.id == self.id then
        defShotEnemiesBullets[k] = nil
      end
    end
  end
end

--- Specifies the type of that object.
-- @param type
-- @return boolean
function BlobEnemyBullet:is(type)
  return type == self.type
end
