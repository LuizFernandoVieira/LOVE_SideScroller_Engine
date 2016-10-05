Ladder         = {}
Ladder.__index = Ladder

setmetatable(Ladder, {
  __index = GameObject,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local LADDER_IMAGE = "img/ladder.png"

---
--
function Ladder:_init(x, y)
  GameObject:_init(x, y)

  self.type      = "Ladder"
  self.sprite    = Sprite:_init(LADDER_IMAGE, 1, 1)
  self.box       = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
end

---
--
function Ladder:update(dt)
  self.sprite:update(dt)
end

---
--
function Ladder:draw()
  self.sprite:draw(self.box.x, self.box.y, 0)
end

---
--
function Ladder:drawDebug()
end

---
--
function Ladder:isDead()
  return false
end

---
--
function Ladder:notifyCollision(other)
end

---
--
function Ladder:is(type)
  return type == self.type
end
