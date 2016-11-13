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

--- Initializes a game actor.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
function GameActor:_init(x, y)
  GameObject:_init(x, y)

  self.type = "GameActor"
end

--- Updates the game actor.
-- Called once once each love.update.
-- @param dt Time passed since last update
function GameActor:update(dt)
end

--- Draws the game actor object.
-- Called once once each love.draw.
function GameActor:draw()
end

--- Check if the game actor is alive.
-- @return boolean
function GameActor:isDead()
end

--- Notifies the game actor that a collision involving himself had ocurred.
-- The game actor (subject) had previously subscribed
-- to the collision system (observer).
-- @param other
function GameActor:notifyCollision(other)
end

--- Specifies the type of that object.
-- @param type
-- @return boolean
function GameActor:is(type)
  return type == "GameActor"
end
