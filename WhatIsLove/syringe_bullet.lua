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
  self.type   = "MissleBullet"
  self.sprite = Sprite:_init("img/EnemyFox_Bullet.png", 1, 1)
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

--- Draws the bullet object.
-- Called once once each love.draw.
function SyringeBullet:draw()
  self.sprite:draw(self.box.x, self.box.y, 0, self.facingRight)
end

--- Draws the bite outline and collision area.
-- Called once once each love.draw if debug parameter passed.
function SyringeBullet:drawDebug()
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
function SyringeBullet:isDead()
  if self.distanceLeft > 0 then
    return false
  else
    return true
  end
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
