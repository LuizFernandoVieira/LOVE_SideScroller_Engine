Shotgun         = {}
Shotgun.__index = Shotgun

setmetatable(Shotgun, {
  __index = Weapon,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local SHOTGUN_IMAGE = "img/misc/spr_smoke_1.png"

function Shotgun:_init(x, y)
  Weapon:_init(x, y)

  self.type      = "Shotgun"
  self.sprite    = Sprite:_init(SHOTGUN_IMAGE, 1, 1)
  self.box       = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.collected = false
end

function Shotgun:update(dt)
  self.sprite:update(dt)
end

function Shotgun:draw()
  self.sprite:draw(self.box.x, self.box.y, 0)
end

function Shotgun:drawDebug()
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

function Shotgun:isDead()
  if self.collected then
    return true
  end
  return false
end

function Shotgun:notifyCollision(other)
  if other.type == "Player" then
    self.collected = true
  end
end

function Shotgun:is(type)
  return type == self.type
end
