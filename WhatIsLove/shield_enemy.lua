ShieldEnemy         = {}
ShieldEnemy.__index = ShieldEnemy

setmetatable(ShieldEnemy, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local SHIELD_ENEMY_TYPE  = "ShieldEnemy"
local SHIELD_ENEMY_IDLE_IMAGE = "img/EnemyShieldFoxyyy.png"
local SHIELD_ENEMY_DEF_IMAGE  = "img/EnemyShieldFox.png"
local ENEMY_HEALTH       = 1
local ENEMY_GRAVITY      = 800
local ENEMY_FACINGRIGHT  = true
local ENEMYSTATE_IDLE    = 0
local ENEMYSTATE_DEF     = 1
local hurtSound = love.audio.newSource("audio/hurt.wav")

--- Initializes a enemy.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
function ShieldEnemy:_init(x, y)
  Enemy:_init(x, y)

  self.type           = SHIELD_ENEMY_TYPE
  self.animIdle       = Sprite(SHIELD_ENEMY_IDLE_IMAGE, 1, 1)
  self.animDef        = Sprite(SHIELD_ENEMY_DEF_IMAGE, 1, 1)
  self.sprite         = self.animIdle
  self.box            = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.shield         = Rect(x+20, y, 50, 100)
  self.range          = 80
  self.shootDownTimer = Timer()
  self.shootUpTimer   = Timer()
  self.changeStateCd  = Timer()
  self.state          = ENEMYSTATE_DEF
end

--- Updates the enemy object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function ShieldEnemy:update(dt)
  self.sprite:update(dt)

  self.lastY = self.box.y

  self.yspeed = self.yspeed + ENEMY_GRAVITY * dt
  self.box.y = self.box.y + self.yspeed * dt

  self.box.x = self.box.x + self.xspeed

  -- IDLE STATE
  if self.state == ENEMYSTATE_IDLE then
    print(self.changeStateCd:get())

    if self:isPlayerInRange()
    and self.changeStateCd:get() <= -2 then
      self.state = ENEMYSTATE_DEF
      self.sprite = self.animDef
      self.changeStateCd:set(5)
    else
      self.changeStateCd:update(-dt)
    end

    if self.changeStateCd:get() < 0 then
      self.shootDownTimer:update(dt)
      self.shootUpTimer:update(dt)
    end

    if self:isTimeToShootDown() then
      self:shootDown()
    end
    if self:isTimeToShootUp() then
      self:shootUp()
    end

  -- DEF STATE
  elseif self.state == ENEMYSTATE_DEF then
    if self:isPlayerInRange()
    and self.changeStateCd:get() < 0 then
      self.state = ENEMYSTATE_IDLE
      self.sprite = self.animIdle
    end
  end
end

function ShieldEnemy:isPlayerInRange()
  local cx = self.box.x
  local cy = self.box.y + self.sprite:getHeight()/2
  local point = Vector(player.box.x, player.box.y)
  local circleCenter = Vector(cx, cy)
  if isCollidingPointCircle(point, circleCenter, self.range) then
    return true
  else
    if self.state == ENEMYSTATE_WALKING then
      self.xspeed = 0
    end
    return false
  end
end

function ShieldEnemy:isTimeToShootDown()
  if self.shootDownTimer:get() > 1 then
    self:shootDown()
    self.shootDownTimer:restart()
  end
end

function ShieldEnemy:isTimeToShootUp()
  if self.shootUpTimer:get() > 1.9 then
    self:shootUp()
    self.shootUpTimer:restart()
  end
end

function ShieldEnemy:shootDown()
  print("ATIRA DOWN")
end

function ShieldEnemy:shootUp()
  print("ATIRA UP")
end

--- Draws the enemy object.
-- Called once once each love.draw.
function ShieldEnemy:draw()
  self.sprite:draw(self.box.x, self.box.y, 0, self.facingRight)
end

--- Draws the enemy outline and collision area.
-- Called once once each love.draw if debug parameter passed.
function ShieldEnemy:drawDebug()
  local lg = love.graphics
  local x  = self.box.x
  local y  = self.box.y
  local w  = self.box.w
  local h  = self.box.h
  local cx = self.box.x + self.sprite:getWidth()/2
  local cy = self.box.y + self.sprite:getHeight()/2
  local sx = self.shield.x
  local sy = self.shield.y
  local sw = self.shield.w
  local sh = self.shield.h
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

--- Specifies the type of that object.
-- @param type
-- @return boolean
function ShieldEnemy:is(type)
  return type == self.type
end
