Lasergun         = {}
Lasergun.__index = Lasergun

setmetatable(Lasergun, {
  __index = Weapon,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local LASERGUN_IMAGE = "img/misc/spr_smoke_4.png"

function Lasergun:_init(x, y)
  Weapon:_init(x, y)

  self.type      = "Lasergun"
  self.sprite    = Sprite:_init(LASERGUN_IMAGE, 1, 1)
  self.box       = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.collected = false
end

function Lasergun:update(dt)
  self.sprite:update(dt)
end

function Lasergun:draw()
  self.sprite:draw(self.box.x, self.box.y, 0)
end

function Lasergun:drawDebug()
  love.graphics.setColor(255, 0, 0, 50)
  love.graphics.rectangle(
    "fill",
    self.box.x,
    self.box.y,
    self.box.w,
    self.box.h
  )
  love.graphics.setColor(255, 0, 0)
  love.graphics.rectangle(
    "line",
    self.box.x,
    self.box.y,
    self.box.w,
    self.box.h
  )
  love.graphics.setColor(255, 255, 255)
end

function Lasergun:isDead()
  if self.collected then
    return true
  end
  return false
end

function Lasergun:notifyCollision(other)
  if other.type == "Player" then
    self.collected = true
  end
end

function Lasergun:is(type)
  return type == self.type
end
