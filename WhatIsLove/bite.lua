Bite         = {}
Bite.__index = Bite

setmetatable(Bite, {
  __index = GameObject,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Bite:_init(x, y, w, h)
  GameObject:_init(x, y)

  self.type         = "Bite"
  self.box          = Rect(x, y, w, h)
end

function Bite:update(dt)
end

function Bite:draw()
end

function Bite:drawDebug()
end

function Bite:isDead()
  return true
end

function Bite:notifyCollision(other)
end

function Bullet:is(type)
  return type == self.type
end
