RightLeftEnemy         = {}
RightLeftEnemy.__index = RightLeftEnemy

setmetatable(RightLeftEnemy, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local RIGHTLEFT_ENEMY_TYPE  = "RightLeftEnemy"
local RIGHTLEFT_ENEMY_IMAGE = "img/Player_Raiva.png"

local ENEMY_VELOCITY     = 0
local ENEMY_HEALTH       = 1
local ENEMY_GRAVITY      = 800
local ENEMY_FACINGRIGHT  = true
local ENEMYSTATE_IDLE    = 0
local ENEMYSTATE_WALKING = 1

--- Initializes a enemy.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
function RightLeftEnemy:_init(x, y)
  Enemy:_init(x, y)

  self.type            = RIGHTLEFT_ENEMY_TYPE
  self.sprite          = Sprite:_init(RIGHTLEFT_ENEMY_IMAGE, 1, 1)
  self.box             = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.initialPosition = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.range           = 80
  self.standingTime    = 0
  self.walkingTime     = 0
  self.xspeed          = - 0.5
end

--- Updates the enemy object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function RightLeftEnemy:update(dt)
  self.lastY = self.box.y

  self.yspeed = self.yspeed + ENEMY_GRAVITY * dt
  self.box.y = self.box.y + self.yspeed * dt

  self.box.x = self.box.x + self.xspeed

  -- IDLE STATE
  if self.state == ENEMYSTATE_IDLE then
    self.standingTime = self.standingTime + dt
    if isToLongStanding(self) then
      print("To long standing")
      self.state = ENEMYSTATE_WALKING
      self.standingTime = 0
      if self.facingRight then
        self.xspeed = 0.5
      else
        self.xspeed = -0.5
      end
    end
  -- WALKING STATE
  elseif self.state == ENEMYSTATE_WALKING then
    self.walkingTime = self.walkingTime + dt
    if isToLongWalking(self) then
      print("To long walking")
      self.state = ENEMYSTATE_IDLE
      self.xspeed = 0
      self.walkingTime = 0
    else
      walkRightLeft(self)
    end
  end

  self.sprite:update(dt)
end

function isToLongStanding(enemy)
  if enemy.standingTime > 3 then
    return true
  else
    return false
  end
end

function isToLongWalking(enemy)
  if enemy.walkingTime > 9 then
    return true
  else
    return false
  end
end

function walkRightLeft(enemy)
  if enemy.box.x < enemy.initialPosition.x - enemy.range then
    enemy.xspeed = 0.5
    enemy.facingRight = true
  elseif enemy.box.x > enemy.initialPosition.x + enemy.range then
    enemy.xspeed = - 0.5
    enemy.facingRight = false
  end
end

--- Draws the enemy object.
-- Called once once each love.draw.
function RightLeftEnemy:draw()
  self.sprite:draw(self.box.x, self.box.y, 0, self.facingRight)
end

--- Draws the enemy outline and collision area.
-- Called once once each love.draw if debug parameter passed.
function RightLeftEnemy:drawDebug()
  local lg = love.graphics
  local x  = self.box.x
  local y  = self.box.y
  local w  = self.box.w
  local h  = self.box.h
  local ix = self.initialPosition.x
  lg.setColor(255, 0, 0, 50)
  lg.rectangle("fill", x, y, w, h)
  lg.setColor(255, 0, 0)
  lg.rectangle("line", x, y, w, h)
  lg.setColor(255, 255, 0, 50)
  lg.rectangle("fill", ix - self.range, y, self.range * 2, h)
  lg.setColor(255, 255, 0)
  lg.rectangle("line", ix - self.range, y, self.range * 2, h)
  lg.setColor(255, 255, 255)
end

--- Notifies the enemy that a collision involving himself had ocurred.
-- The enemy (subject) had previously subscribed
-- to the collision system (observer).
-- @param other
function RightLeftEnemy:notifyCollision(other)
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
function RightLeftEnemy:is(type)
  return type == self.type
end
