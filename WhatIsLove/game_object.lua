GameObject          = {}
GameObject.__index  = GameObject
nextId              = 0

setmetatable(GameObject, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function GameObject:_init(x, y)
  self.id = nextId
  self.x  = x
  self.y  = y

  nextId = nextId + 1
end

function GameObject:getId()
  return self.id
end

function GameObject:getX()
  return self.x
end

function GameObject:getY()
  return self.y
end

function GameObject:setX(x)
  self.x = x
end

function GameObject:setY(y)
  self.y = y
end
