GameActor         = {}
GameActor.__index = GameActor

setmetatable(GameActor, {
  __index = GameObject,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

---
--
-- @param x
-- @param y
function GameActor:_init(x, y)
  GameObject:_init(x, y)

  self.type = "GameActor"
  self.box  = Rect(x, y, 0, 0)
end

--- Updates the game actor
-- Called once once each love.update
-- @param dt Time passed since last update
function GameActor:update(dt)
end

---
--
function GameActor:draw()
end

---
--
function GameActor:isDead()
end

---
--
-- @param other
function GameActor:notifyCollision(other)
end

---
--
-- @param type
-- @return boolean
function GameActor:is(type)
  return type == "GameActor"
end
