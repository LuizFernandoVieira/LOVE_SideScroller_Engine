Rect          = {}
Rect.__index  = Rect

setmetatable(Rect, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Rect:_init(x, y, w, h)
  self.x = x
  self.y = y
  self.w = w
  self.h = h
end

function Rect:center()
  return Vector(self.x + self.w/2, self.y + self.h/2)
end

function Rect:center(x, y)
  x = self.x + self.w/2
  y = self.y + self.h/2
end

function Rect:isInside(vector)
  if (vector.x >= self.x
  and vector.x <= self.x + self.w
  and vector.y >= self.y
  and vector.y <= self.y + self.h) then
    return true
  else
    return false
  end
end
