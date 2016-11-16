BossBomb         = {}
BossBomb.__index = BossBomb

setmetatable(BossBomb, {
  __index = GameObject,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local BULLET_IMAGE = "img/BossBullet_Placeholder.png"

--- Initializes a bullet.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
-- @param speed Quantity that represents how fast this bullet moves
-- @param distanceLeft Amount of space left before the bullet is destroyed
function BossBomb:_init(x, y, speed, distanceLeft, speedY)
  GameObject:_init(x, y)

  self.type         = "BossBomb"
  self.sprite       = Sprite(BULLET_IMAGE, 1, 1)
  self.speedX       = speed or 0
  self.speedY       = speedY or 0
  self.distanceLeft = distanceLeft
  self.box          = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
end

--- Updates the bullet object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function BossBomb:update(dt)
  self.sprite:update(dt)

  local previousX   = self.box.x
  local previousY   = self.box.y
  self.box.x        = self.box.x + self.speedX * dt
  self.box.y        = self.box.y + self.speedY * dt

  self.distanceLeft = self.distanceLeft - math.sqrt( math.pow((self.box.x - previousX), 2) + math.pow((self.box.y - previousY), 2) )
end

--- Draws the bullet object.
-- Called once once each love.draw.
function BossBomb:draw()
  self.sprite:draw(self.box.x, self.box.y)
end

--- Draws the bite outline and collision area.
-- Called once once each love.draw if debug parameter passed.
function BossBomb:drawDebug()
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
function BossBomb:isDead()
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
function BossBomb:notifyCollision(other)
  if other.type == "Player" then
    for k,v in ipairs(boss.bombs) do
      if v.id == other.id then
        boss.bombs[k] = nil
      end
    end
  end
end

--- Specifies the type of that object.
-- @param type
-- @return boolean
function BossBomb:is(type)
  return type == self.type
end
