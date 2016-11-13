DefShotEnemy         = {}
DefShotEnemy.__index = DefShotEnemy

setmetatable(DefShotEnemy, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local DEFSHOT_ENEMY_TYPE            = "DefShotEnemy"
local DEFSHOT_ENEMY_HIDING_IMAGE    = "img/EnemyShellIdle.png"
local DEFSHOT_ENEMY_ATTACKING_IMAGE = "img/EnemyShellAttacking.png"
local ENEMY_HEALTH                  = 1
local ENEMY_GRAVITY                 = 800
local ENEMYSTATE_HIDING             = 0
local ENEMYSTATE_ATTACKING          = 1
local hurtSound = love.audio.newSource("audio/hurt.wav")
local defSound  = love.audio.newSource("audio/def.wav")

--- Initializes a enemy.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
function DefShotEnemy:_init(x, y)
  Enemy:_init(x, y)

  self.type          = DEFSHOT_ENEMY_TYPE
  self.state         = ENEMYSTATE_HIDING
  self.hidingTime    = 0
  self.attackingTime = 0
  self.shotTime      = 0

  self.animHiding    = Sprite(DEFSHOT_ENEMY_HIDING_IMAGE, 1, 1)
  self.animAttacking = Sprite(DEFSHOT_ENEMY_ATTACKING_IMAGE, 12, 0.1)
  self.sprite        = self.animHiding
  self.box           = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
end

--- Updates the enemy object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function DefShotEnemy:update(dt)
  self.sprite:update(dt)
  
  self.lastY = self.box.y

  self.yspeed = self.yspeed + ENEMY_GRAVITY * dt
  self.box.y = self.box.y + self.yspeed * dt

  -- HIDING STATE
  if self.state == ENEMYSTATE_HIDING then
    self.hidingTime = self.hidingTime + dt
    if self:isToLongHiding() then
      self.state = ENEMYSTATE_ATTACKING
      self.sprite = self.animAttacking
      self.hidingTime = 0
    end
  -- ATTACKING STATE
  elseif self.state == ENEMYSTATE_ATTACKING then
    self.attackingTime = self.attackingTime + dt
    self.shotTime = self.shotTime + dt
    if self.shotTime > 0.6 then
      self:shot()
      self.shotTime = 0
    end
    if self:isToLongAttacking() then
      self.state = ENEMYSTATE_HIDING
      self.sprite = self.animHiding
      self.attackingTime = 0
      self.shotTime = 0
    end
  end
end

function DefShotEnemy:isToLongHiding()
  if self.hidingTime > 3 then return true
  else return false end
end

function DefShotEnemy:isToLongAttacking()
  if self.attackingTime > 1 then return true
  else return false end
end

function DefShotEnemy:shot()
  local x = self.box.x - 6
  local y = self.box.y + 6
  local distLeft = 10000
  table.insert(defShotEnemiesBullets, DefShotEnemiesBullets(x, y,  50, distLeft, -50))
  table.insert(defShotEnemiesBullets, DefShotEnemiesBullets(x, y, -50, distLeft, -50))
  table.insert(defShotEnemiesBullets, DefShotEnemiesBullets(x, y,  00, distLeft, -50))
  table.insert(defShotEnemiesBullets, DefShotEnemiesBullets(x, y, -50, distLeft,  00))
  table.insert(defShotEnemiesBullets, DefShotEnemiesBullets(x, y,  50, distLeft,  00))
end

--- Draws the enemy object.
-- Called once once each love.draw.
function DefShotEnemy:draw()
  self.sprite:draw(self.box.x, self.box.y, 0, self.facingRight)
end

--- Draws the enemy outline and collision area.
-- Called once once each love.draw if debug parameter passed.
function DefShotEnemy:drawDebug()
  local lg = love.graphics
  local x  = self.box.x
  local y  = self.box.y
  local w  = self.box.w
  local h  = self.box.h
  lg.setColor(255, 0, 0, 50)
  lg.rectangle("fill", x, y, w, h)
  lg.setColor(255, 0, 0)
  lg.rectangle("line", x, y, w, h)
  lg.setColor(255, 255, 0, 50)
end

--- Notifies the enemy that a collision involving himself had ocurred.
-- The enemy (subject) had previously subscribed
-- to the collision system (observer).
-- @param other
function DefShotEnemy:notifyCollision(other)
  if other.type == "Tile" then
    self.grounded = true
    self.yspeed = 0
    self.box.y = self.lastY
  elseif other.type == "Bullet"
  or     other.type == "MissleBullet"
  or     other.type == "ShotgunBullet"
  or     other.type == "MachinegunBullet" then
    if self.state == ENEMYSTATE_ATTACKING then
      hurtSound:play()
      self.health = 0
    else
      defSound:play()
    end
  elseif other.type == "Bite" then
    if self.state == ENEMYSTATE_ATTACKING then
      self.health = 0
    end
  end
end

--- Specifies the type of that object.
-- @param type
-- @return boolean
function DefShotEnemy:is(type)
  return type == self.type
end
