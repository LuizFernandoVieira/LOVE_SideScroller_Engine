SyringeBullet         = {}
SyringeBullet.__index = SyringeBullet

setmetatable(SyringeBullet, {
  __index = Bullet,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function SyringeBullet:_init(x, y, speed, distanceLeft, facingRight)
  Bullet:_init(x, y, speed, distanceLeft)
  self.type   = "SyringeBullet"
  self.sprite = Sprite("img/EnemyFox_Bullet.png", 1, 1)
  self.facingRight = facingRight
  self.speedX       = speed
  self.speedY       = speedY or 0
  self.distanceLeft = distanceLeft
  self.box    = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
end

--- Updates the bullet object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function SyringeBullet:update(dt)
  self.sprite:update(dt)

  local previousX   = self.box.x
  local previousY   = self.box.y
  self.box.x        = self.box.x + self.speedX * dt
  self.box.y        = self.box.y + self.speedY * dt

  self.distanceLeft = self.distanceLeft - math.sqrt( math.pow((self.box.x - previousX), 2) + math.pow((self.box.y - previousY), 2) )
end

function SyringeBullet:notifyCollision(other)
  if other.type == "Enemy"
  or other.type == "ChaseEnemy"
  or other.type == "FlybombEnemy"
  or other.type == "RightLeftEnemy"
  or other.type == "DefShotEnemy" then
    for k,v in ipairs(missleBullets) do
      if v.id == other.id then
        missleBullets[k] = nil
      end
    end
  end
end

--- Specifies the type of that object.
-- @param type
-- @return boolean
function SyringeBullet:is(type)
  return type == self.type
end
