MachinegunBullet         = {}
MachinegunBullet.__index = MachinegunBullet

setmetatable(MachinegunBullet, {
  __index = Bullet,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local BULLET_IMAGE = "img/GunShotgun_Bullet.png"

--- Initializes a bullet.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
-- @param speed Quantity that represents how fast this bullet moves
-- @param distanceLeft Amount of space left before the bullet is destroyed
function MachinegunBullet:_init(x, y, speed, distanceLeft, speedY)
  Bullet:_init(x, y)

  self.type         = "MachinegunBullet"
  self.sprite       = Sprite(BULLET_IMAGE, 1, 1)
  self.speedX       = speed
  self.speedY       = speedY or 0
  self.distanceLeft = distanceLeft
  self.box          = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
end

--- Updates the bullet object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function MachinegunBullet:update(dt)
  self.sprite:update(dt)

  local previousX   = self.box.x
  local previousY   = self.box.y
  self.box.x        = self.box.x + self.speedX * dt
  self.box.y        = self.box.y + self.speedY * dt

  self.distanceLeft = self.distanceLeft - math.sqrt( math.pow((self.box.x - previousX), 2) + math.pow((self.box.y - previousY), 2) )
end

--- Notifies the bite that a collision involving himself had ocurred.
-- The bullet (subject) had previously subscribed
-- to the collision system (observer).
-- @param other
function MachinegunBullet:notifyCollision(other)
  if other.type == "Enemy"
  or other.type == "ChaseEnemy"
  or other.type == "RightLeftEnemy"
  or other.type == "DefShotEnemy"
  or other.type == "FlybombEnemy"
  or other.type == "ShootEnemy" then
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
function MachinegunBullet:is(type)
  return type == self.type
end
