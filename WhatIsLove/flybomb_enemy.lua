FlybombEnemy         = {}
FlybombEnemy.__index = FlybombEnemy

setmetatable(FlybombEnemy, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local FLYBOMB_ENEMY_TYPE  = "FlybombEnemy"
local FLYBOMB_ENEMY_IMAGE = "img/EnemyFox-o-copter.png"

local ENEMY_VELOCITY     = 0
local ENEMY_HEALTH       = 1
local ENEMY_GRAVITY      = 800
local ENEMY_FACINGRIGHT  = true
local ENEMYSTATE_IDLE    = 0
local ENEMYSTATE_WALKING = 1
local ENEMYSTATE_FLYING  = 2

--- Initializes a enemy.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
function FlybombEnemy:_init(x, y)
  Enemy:_init(x, y)

  self.type             = FLYBOMB_ENEMY_TYPE
  self.sprite           = Sprite:_init(FLYBOMB_ENEMY_IMAGE, 2, 0.1)
  self.box              = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.initialPosition  = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.range            = 80
  self.standingTime     = 0
  self.flyingTime       = 0
  self.xspeed           = - 0.5
  self.dropBombCooldown = 5
  self.dropTiming       = 5
end

--- Updates the enemy object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function FlybombEnemy:update(dt)
  self.lastY = self.box.y

  self.box.x = self.box.x + self.xspeed

  -- IDLE STATE
  if self.state == ENEMYSTATE_IDLE then
    self.standingTime = self.standingTime + dt
    if isToLongStanding(self) then
      print("To long standing")
      self.state = ENEMYSTATE_FLYING
      self.standingTime = 0
      self:dropBomb()
      if self.facingRight then
        self.xspeed = 0.5
      else
        self.xspeed = -0.5
      end
    end
  -- FLYING STATE
  elseif self.state == ENEMYSTATE_FLYING then
    self.flyingTime = self.flyingTime + dt
    if isToLongFlying(self) then
      print("To long flying")
      self.state = ENEMYSTATE_IDLE
      self.xspeed = 0
      self.flyingTime = 0
    else
      flyRightLeft(self)
    end
  end

  self.sprite:update(dt)
end

function isToLongStanding(enemy)
  if enemy.standingTime > 0.4 then
    return true
  else
    return false
  end
end

function isToLongFlying(enemy)
  if enemy.flyingTime > 2 then
    return true
  else
    return false
  end
end

function flyRightLeft(enemy)
  if enemy.box:center().x < enemy.initialPosition.x - enemy.range then
    enemy.xspeed = 0.5
    enemy.facingRight = true
  elseif enemy.box:center().x > enemy.initialPosition.x + enemy.range then
    enemy.xspeed = - 0.5
    enemy.facingRight = false
  end
end

function FlybombEnemy:dropBomb()
  table.insert(bombs, Bomb(self.box.x, self.box.y))
end

--- Draws the enemy object.
-- Called once once each love.draw.
function FlybombEnemy:draw()
  self.sprite:draw(self.box.x, self.box.y, 0, self.facingRight)
end

--- Draws the enemy outline and collision area.
-- Called once once each love.draw if debug parameter passed.
function FlybombEnemy:drawDebug()
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
function FlybombEnemy:notifyCollision(other)
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
function FlybombEnemy:is(type)
  return type == self.type
end
