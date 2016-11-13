SpikeEnemy         = {}
SpikeEnemy.__index = SpikeEnemy

setmetatable(SpikeEnemy, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local hurtSound          = love.audio.newSource("audio/hurt.wav")
local SPIKE_ENEMY_TYPE  = "SpikeEnemy"
local SPIKE_ENEMY_IMAGE = "img/spike.png"
local ENEMYSTATE_WALKING = 0

--- Initializes a enemy.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
function SpikeEnemy:_init(x, y)
  Enemy:_init(x, y)

  self.type             = SPIKE_ENEMY_TYPE
  self.sprite           = Sprite(SPIKE_ENEMY_IMAGE, 1, 1)
  self.box              = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.initialPosition  = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.range            = 30
  self.goingUp          = true
  self.yspeed           = - 0.5
end

--- Updates the enemy object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function SpikeEnemy:update(dt)
  self.sprite:update(dt)

  if self.box.y > self.initialPosition.y + self.range then
    self.goingUp = true
  elseif self.box.y < self.initialPosition.y - self.range then
    self.goingUp = false
  end

  if self.goingUp then
    self.yspeed = -0.5
  else
    self.yspeed = 0.5
  end

  self.box.y = self.box.y + self.yspeed
end

--- Draws the enemy object.
-- Called once once each love.draw.
function SpikeEnemy:draw()
  self.sprite:draw(self.box.x, self.box.y, 0, self.facingRight)
end

--- Draws the enemy outline and collision area.
-- Called once once each love.draw if debug parameter passed.
function SpikeEnemy:drawDebug()
  local lg = love.graphics
  local x  = self.box.x
  local y  = self.box.y
  local w  = self.box.w
  local h  = self.box.h
  local iy = self.initialPosition.y
  lg.setColor(255, 0, 0, 50)
  lg.rectangle("fill", x, y, w, h)
  lg.setColor(255, 0, 0)
  lg.rectangle("line", x, y, w, h)
  lg.setColor(255, 255, 0, 50)
  lg.rectangle("fill", x, iy - self.range, w, 2 * self.range)
  lg.setColor(255, 255, 0)
  lg.rectangle("line", x, iy - self.range, w, 2 * self.range)
  lg.setColor(255, 255, 255)
end

--- Specifies the type of that object.
-- @param type
-- @return boolean
function SpikeEnemy:is(type)
  return type == self.type
end
