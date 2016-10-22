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

function ShotgunBullet:_init(x, y, speed, distanceLeft)
  Bullet:_init(x, y, speed, distanceLeft)
  self.type   = "ShotgunBullet"
  self.sprite = Sprite:_init("img/GunMachinegun_bullet.png", 1, 1)
  self.box    = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
end

function ShotgunBullet:notifyCollision(other)
  if other.type == "Enemy" then
    for k,v in ipairs(shotgunBullets) do
      if v.id == other.id then
        missleBullets[k] = nil
      end
    end
  end
end
