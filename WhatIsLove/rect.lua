Rect          = {}
Rect.__index  = Rect

setmetatable(Rect, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

--- Initializes rect.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
-- @param w Width of the rect
-- @param h Height of the rect
function Rect:_init(x, y, w, h)
  self.x = x
  self.y = y
  self.w = w
  self.h = h
end

--- Gets the center of this rectangle.
-- @return table
function Rect:center()
  return Vector(self.x + self.w/2, self.y + self.h/2)
end

--- Checks if a vector is inside this rectangle.
-- @param vector
-- @return boolean
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
