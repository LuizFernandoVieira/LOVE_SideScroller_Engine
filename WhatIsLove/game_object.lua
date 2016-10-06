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

--- Initializes game object.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
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

--- Draws the game object.
-- Called once once each love.draw.
function GameObject:draw()
end

--- Check if the game object is alive.
-- @return boolean
function GameObject:isDead()
end

--- Notifies the game object that a collision involving himself had ocurred.
-- The game object (subject) had previously subscribed
-- to the collision system (observer).
-- @param other
function GameObject:notifyCollision(other)
end

--- Specifies the type of that object.
-- @param type
-- @return boolean
function GameObject:is(type)
  return type == "GameObject"
end
