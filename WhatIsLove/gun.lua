Gun         = {}
Gun.__index = Gun

setmetatable(Gun, {
  __index = Weapon,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local GUN_IMAGE = "img/misc/spr_smoke_2.png"

--- Initializes gun.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
function Gun:_init(x, y)
  Weapon:_init(x, y)

  self.type      = "Gun"
  self.sprite    = Sprite(GUN_IMAGE, 1, 1)
  self.box       = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.collected = false
end

--- Updates the gun object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function Gun:update(dt)
  self.sprite:update(dt)
end

--- Draws the gun object.
-- Called once once each love.draw.
function Gun:draw()
  self.sprite:draw(self.box.x, self.box.y, 0)
end

--- Draws the gun outline and collision area.
-- Called once once each love.draw if debug parameter passed.
function Gun:drawDebug()
  local lg = love.graphics
  local x  = self.box.x
  local y  = self.box.y
  local w  = self.box.w
  local h  = self.box.h
  lg.setColor(255, 0, 0, 50)
  lg.rectangle("fill", x, y, w, h)
  lg.setColor(255, 0, 0)
  lg.rectangle("line", x, y, w, h)
  lg.setColor(255, 255, 255)
end

--- Checks if gun has been collected.
-- Once the gun has been collected it shoud be destroyed.
-- @return boolean
function Gun:isDead()
  if self.collected then
    return true
  end
  return false
end

--- Notifies the gun that a collision involving himself had ocurred.
-- The gun (subject) had previously subscribed
-- to the collision system (observer).
-- @param other
function Gun:notifyCollision(other)
  if other.type == "Player" then
    self.collected = true
  end
end

--- Specifies the type of that object.
-- @param type
-- @return boolean
function Gun:is(type)
  return type == self.type
end
