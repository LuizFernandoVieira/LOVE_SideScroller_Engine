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

function MissleBullet:_init(x, y, speed, distanceLeft)
  Bullet:_init(x, y, speed, distanceLeft)
  self.type = "MissleBullet"
end

function MissleBullet:notifyCollision(other)
  if other.type == "Enemy" then
    for k,v in ipairs(missleBullets) do
      if v.id == other.id then
        missleBullets[k] = nil
      end
    end
    table.insert(bite, Bite(self.box.x-8, self.box.y-8, 32, 32))
  end
end
