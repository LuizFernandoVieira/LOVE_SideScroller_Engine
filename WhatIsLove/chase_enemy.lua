ChaseEnemy         = {}
ChaseEnemy.__index = ChaseEnemy

setmetatable(ChaseEnemy, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local CHASE_ENEMY_TYPE         = "ChaseEnemy"
local CHASE_ENEMY_IMAGE        = "img/Player_Raiva.png"

local ENEMY_VELOCITY     = 0
local ENEMY_HEALTH       = 1
local ENEMY_GRAVITY      = 800
local ENEMY_FACINGRIGHT  = true
local ENEMYSTATE_IDLE    = 0
local ENEMYSTATE_WALKING = 1

--- Initializes a enemy.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
function ChaseEnemy:_init(x, y)
  Enemy:_init(x, y)

  self.type   = CHASE_ENEMY_TYPE
  self.sprite = Sprite:_init(CHASE_ENEMY_IMAGE, 1, 1)
  self.box    = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.range  = 80
end

--- Updates the enemy object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function ChaseEnemy:update(dt)
  self.lastY = self.box.y

  self.yspeed = self.yspeed + ENEMY_GRAVITY * dt
  self.box.y = self.box.y + self.yspeed * dt

  self.box.x = self.box.x + self.xspeed

  -- IDLE STATE
  if self.state == ENEMYSTATE_IDLE then
    if isPlayerInRange(self) then
      self.state = ENEMYSTATE_WALKING
    end
  -- WALKING STATE
  elseif self.state == ENEMYSTATE_WALKING then
    if isPlayerInRange(self) then
      chasePlayer(self)
    else
      self.state = ENEMYSTATE_IDLE
    end
  end

  self.sprite:update(dt)
end

function isPlayerInRange(enemy)
  local cx = enemy.box.x
  local cy = enemy.box.y + enemy.sprite:getHeight()/2
  local point = Vector(player.box.x, player.box.y)
  local circleCenter = Vector(cx, cy)
  if isCollidingPointCircle(point, circleCenter, enemy.range) then
    return true
  else
    if enemy.state == ENEMYSTATE_WALKING then
      enemy.xspeed = 0
    end
    return false
  end
end

function chasePlayer(enemy)
  -- anda esquerda
  if player.box.x < enemy.box.x then
    enemy.xspeed = - 0.7
  -- anda direita
  else
    enemy.xspeed = 0.7
  end
end

--- Draws the enemy object.
-- Called once once each love.draw.
function ChaseEnemy:draw()
  self.sprite:draw(self.box.x, self.box.y, 0, self.facingRight)
end

--- Draws the enemy outline and collision area.
-- Called once once each love.draw if debug parameter passed.
function ChaseEnemy:drawDebug()
  local lg = love.graphics
  local x  = self.box.x
  local y  = self.box.y
  local w  = self.box.w
  local h  = self.box.h
  local cx = self.box.x + self.sprite:getWidth()/2
  local cy = self.box.y + self.sprite:getHeight()/2
  lg.setColor(255, 0, 0, 50)
  lg.rectangle("fill", x, y, w, h)
  lg.setColor(255, 0, 0)
  lg.rectangle("line", x, y, w, h)
  lg.setColor(255, 255, 0, 50)
  lg.circle("fill", cx, cy, self.range, 100)
  lg.setColor(255, 255, 0)
  lg.circle("line", cx, cy, self.range, 100)
  lg.setColor(255, 255, 255)
end

--- Notifies the enemy that a collision involving himself had ocurred.
-- The enemy (subject) had previously subscribed
-- to the collision system (observer).
-- @param other
function ChaseEnemy:notifyCollision(other)
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
function ChaseEnemy:is(type)
  return type == self.type
end
