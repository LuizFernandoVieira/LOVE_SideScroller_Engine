Enemy         = {}
Enemy.__index = Enemy

setmetatable(Enemy, {
  __index = GameActor,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local ENEMY_TYPE         = "Enemy"
local ENEMY_IMAGE        = "img/EnemyFox.png"
local ENEMY_VELOCITY     = 1
local ENEMY_HEALTH       = 1
local ENEMY_GRAVITY      = 800
local ENEMY_FACINGRIGHT  = true
local ENEMYSTATE_IDLE    = 0
local ENEMYSTATE_WALKING = 1
local ENEMYSTATE_FLYING  = 2

--- Initializes a enemy.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
function Enemy:_init(x, y)
  GameActor:_init(x, y)

  self.type        = ENEMY_TYPE
  self.facingRight = true
  self.velocity    = ENEMY_VELOCITY
  self.health      = ENEMY_HEALTH
  self.grounded    = false
  self.sprite      = Sprite:_init(ENEMY_IMAGE, 1, 1)
  self.box         = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.xspeed      = 0
  self.yspeed      = 0
  self.state       = ENEMYSTATE_IDLE
  self.grounded    = false
  self.lastY       = y
end

--- Updates the enemy object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function Enemy:update(dt)
  self.sprite:update(dt)

  self.lastY = self.box.y

  self.yspeed = self.yspeed + ENEMY_GRAVITY * dt
  self.box.y = self.box.y + self.yspeed * dt

  self.box.x = self.box.x + self.xspeed * dt

  self.box.x = math.floor(self.box.x)
  self.box.y = math.floor(self.box.y)
end

--- Draws the enemy object.
-- Called once once each love.draw.
function Enemy:draw()
  self.sprite:draw(self.box.x, self.box.y, 0, self.facingRight)
end

--- Draws the enemy outline and collision area.
-- Called once once each love.draw if debug parameter passed.
function Enemy:drawDebug()
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

--- Check if enemy still have health.
-- If not it should be destroyed.
-- @return boolean
function Enemy:isDead()
  if self.health == 0 then
    return true
  else
    return false
  end
end

--- Notifies the enemy that a collision involving himself had ocurred.
-- The enemy (subject) had previously subscribed
-- to the collision system (observer).
-- @param other
function Enemy:notifyCollision(other)
  if other.type == "Tile" then
    self.grounded = true
    self.yspeed = 0
    self.box.y = self.lastY
  elseif other.type == "Bullet" then
    self.health = 0
  elseif other.type == "Bite" then
    self.health = 0
  end
end

--- Specifies the type of that object.
-- @param type
-- @return boolean
function Enemy:is(type)
  return type == self.type
end
