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

local BULLET_IMAGE = "img/misc/spr_star_0.png"

function Bullet:_init(x, y, speed, distanceLeft)
  GameObject:_init(x, y)

  self.type         = "Bullet"
  self.sprite       = Sprite:_init(BULLET_IMAGE, 1, 1)
  self.speedX       = speed
  self.distanceLeft = distanceLeft
  self.box          = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
end

function Bullet:update(dt)
  self.sprite:update(dt)

  local previousX   = self.box.x
  self.box.x        = self.box.x + self.speedX * dt;
  self.distanceLeft = self.distanceLeft - math.abs(previousX)
end

function Bullet:draw()
  self.sprite:draw(self.box.x, self.box.y, 0)
end

function Bullet:drawDebug()
  love.graphics.setColor(255, 255, 0, 50)
  love.graphics.rectangle(
    "fill",
    self.box.x,
    self.box.y,
    16,16
  )
  love.graphics.setColor(255, 255, 0)
  love.graphics.rectangle(
    "line",
    self.box.x,
    self.box.y,
    16,16
  )
  love.graphics.setColor(255, 255, 255)
end

function Bullet:isDead()
  if distanceLeft > 0 then
    return false
  else
    return true
  end
end

function Bullet:notifyCollision(other)
  if other.type == "Enemy" then
    for k,v in ipairs(bullets) do
      if v.id == other.id then
        bullets[k] = nil
      end
    end
  end
end

function Bullet:is(type)
  return type == self.type
end
