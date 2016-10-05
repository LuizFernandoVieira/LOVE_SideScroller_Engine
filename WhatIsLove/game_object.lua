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

--- Initializes game object
--
-- @param x
-- @param y
function GameObject:_init(x, y)
  self.id       = nextId
  self.type     = "GameObject"
  self.box      = Rect(x, y, 0, 0)
  self.rotation = 0

  nextId = nextId + 1
end

--- Updates the game object
-- Called once once each love.update
-- @param dt Time passed since last update
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
-- @param other
function GameObject:notifyCollision(other)
end

---
--
-- @param type
-- @return boolean
function GameObject:is(type)
  return type == "GameObject"
end
