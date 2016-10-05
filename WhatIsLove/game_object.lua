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

---
--
function GameObject:_init(x, y)
  self.id       = nextId
  self.type     = "GameObject"
  self.box      = Rect(x, y, 0, 0)
  self.rotation = 0

  nextId = nextId + 1
end

---
--
function GameObject:update(dt)
end

---
--
function GameObject:draw()
end

---
--
function GameObject:isDead()
end

---
--
function GameObject:notifyCollision(other)
end

---
-- 
function GameObject:is(type)
  return type == "GameObject"
end
