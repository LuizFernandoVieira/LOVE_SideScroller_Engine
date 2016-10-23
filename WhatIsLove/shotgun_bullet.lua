ShotgunBullet         = {}
ShotgunBullet.__index = ShotgunBullet

setmetatable(ShotgunBullet, {
  __index = Bullet,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function ShotgunBullet:_init(x, y, speed, distanceLeft, facingRight)
  Bullet:_init(x, y, speed, distanceLeft)
  self.type   = "ShotgunBullet"
  self.facingRight  = facingRight
  self.speedX       = speed
  self.speedY       = speedY or 0
  self.distanceLeft = distanceLeft
  self.sprite = Sprite:_init("img/GunMachinegun_bullet.png", 1, 1)
  self.box    = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
end

function ShotgunBullet:draw()
  self.sprite:draw(self.box.x, self.box.y, 0, self.facingRight)
end


function ShotgunBullet:notifyCollision(other)
  if other.type == "Enemy"
  or other.type == "ChaseEnemy"
  or other.type == "RightLeftEnemy"
  or other.type == "DefShotEnemy"
  or other.type == "FlybombEnemy" then
    for k,v in ipairs(shotgunBullets) do
      if v.id == other.id then
        missleBullets[k] = nil
      end
    end
  end
end
