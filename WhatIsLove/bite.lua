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

---
--
function Bite:_init(x, y, w, h)
  GameObject:_init(x, y)

  self.type         = "Bite"
  self.box          = Rect(x, y, w, h)
end

---
--
function Bite:update(dt)
end

---
--
function Bite:draw()
end

---
--
function Bite:drawDebug()
  love.graphics.setColor(255, 0, 255, 50)
  love.graphics.rectangle(
    "fill",
    self.box.x,
    self.box.y,
    32, 32
  )
  love.graphics.setColor(255, 0, 255)
  love.graphics.rectangle(
    "line",
    self.box.x,
    self.box.y,
    32, 32
  )
  love.graphics.setColor(255, 255, 255)
end

---
--
function Bite:isDead()
  return true
end

---
--
function Bite:notifyCollision(other)
end

---
-- 
function Bullet:is(type)
  return type == self.type
end
