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
function GameActor:_init(x, y)
  GameObject:_init(x, y)

  self.type = "GameActor"
  self.box  = Rect(x, y, 0, 0)
end

---
--
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
function GameActor:notifyCollision(other)
end

---
-- 
function GameActor:is(type)
  return type == "GameActor"
end
