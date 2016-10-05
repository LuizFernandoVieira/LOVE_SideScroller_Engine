Vector          = {}
Vector.__index  = Vector

setmetatable(Vector, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

PI = 3.14

---
--
function Vector:_init(x, y)
  self.x = x
  self.y = y
end

---
-- 
function Vector:rotate(angle)
  angle = angle * PI / 180
  local curX = self.x
  local curY = self.y
  self.x = curX * math.cos(angle) - curY * math.sin(angle)
  self.y = curY * math.cos(angle) - curX * math.sin(angle)
end
