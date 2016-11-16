BossSpikePos         = {}
BossSpikePos.__index = BossSpikePos

setmetatable(BossSpikePos, {
  __index = GameObject,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local BITE_TYPE  = "BossSpikePos"
local BITE_IMAGE = "img/BossCarrot_SpikeMarker.png"

--- Initializes a bite.
-- Bite's are created every time a infected player tries to attack.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
-- @param w Width of the collision area of that bite
-- @param h Height of the collision area of that bite
function BossSpikePos:_init(x, y)
  GameObject:_init(x, y)

  self.type         = BITE_TYPE
  self.sprite       = Sprite(BITE_IMAGE, 1, 1)
  self.box          = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.facingRight  = true
  self.lifeTime     = Timer()
end

--- Updates the bite object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function BossSpikePos:update(dt)
  self.sprite:update(dt)
  self.lifeTime:update(dt)
end

--- Draws the antidote object.
-- Called once once each love.draw.
function BossSpikePos:draw()
  if self.lifeTime:get() < 1.2 then
    self.sprite:draw(self.box.x, self.box.y, 0, self.facingRight)
  end
end

--- Draws the bite outline and collision area.
-- Called once once each love.draw if debug parameter passed.
function BossSpikePos:drawDebug()
  local lg = love.graphics
  local x  = self.box.x
  local y  = self.box.y
  local w  = self.box.w
  local h  = self.box.h
  lg.setColor(255, 0, 255, 50)
  lg.rectangle("fill", x, y, w, h)
  lg.setColor(255, 0, 255)
  lg.rectangle("line", x, y, w, h)
  lg.setColor(255, 255, 255)
end

--- Bite is killed after instantiate.
-- @return boolean
function BossSpikePos:isDead()
  if self.lifeTime:get() > 3 then
    return true
  else
    return false
  end
end

--- Notifies the bite that a collision involving himself had ocurred.
-- The antidote (subject) had previously subscribed
-- to the collision system (observer).
-- @param other Object that collided with the bite
function BossSpikePos:notifyCollision(other)
end

--- Specifies the type of that object.
-- @param type
-- @return boolean
function BossSpikePos:is(type)
  return type == self.type
end
