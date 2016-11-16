MissleBullet         = {}
MissleBullet.__index = MissleBullet

setmetatable(MissleBullet, {
  __index = Bullet,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function MissleBullet:_init(x, y, speed, distanceLeft, facingRight)
  Bullet:_init(x, y, speed, distanceLeft)
  self.type   = "MissleBullet"
  self.sprite = Sprite("img/GunMisselLaucher_bullet.png", 1, 1)
  self.facingRight = facingRight
  self.speedX       = speed
  self.speedY       = speedY or 0
  self.distanceLeft = distanceLeft
  self.box    = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
end

--- Updates the bullet object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function MissleBullet:update(dt)
  self.sprite:update(dt)

  local previousX   = self.box.x
  local previousY   = self.box.y
  self.box.x        = self.box.x + self.speedX * dt
  self.box.y        = self.box.y + self.speedY * dt

  self.distanceLeft = self.distanceLeft - math.sqrt( math.pow((self.box.x - previousX), 2) + math.pow((self.box.y - previousY), 2) )
end

function MissleBullet:notifyCollision(other)
  if other.type == "Enemy"
  or other.type == "ChaseEnemy"
  or other.type == "FlybombEnemy"
  or other.type == "RightLeftEnemy"
  or other.type == "DefShotEnemy"
  or other.type == "ShootEnemy" then
    for k,v in ipairs(missleBullets) do
      if v.id == other.id then
        missleBullets[k] = nil
      end
    end
    -- table.insert(missleBullets, MissleExplosion(self.box.x-self.sprite:getWidth()/3, self.box.y-self.sprite:getHeight()-8))
    table.insert(missleBullets, MissleExplosion(self.box.x, self.box.y-self.sprite:getHeight()-8))
  end
end

--- Specifies the type of that object.
-- @param type
-- @return boolean
function MachinegunBullet:is(type)
  return type == self.type
end
