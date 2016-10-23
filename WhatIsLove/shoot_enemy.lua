ShootEnemy         = {}
ShootEnemy.__index = ShootEnemy

setmetatable(ShootEnemy, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local SHOOTENEMY_TYPE         = "ShootEnemy"
local SHOOTENEMY_IMAGE        = "img/EnemyFox.png"
local SHOOTENEMY_VELOCITY     = 1
local SHOOTENEMY_HEALTH       = 1
local SHOOTENEMY_GRAVITY      = 800
local SHOOTENEMY_FACINGRIGHT  = true
local SHOOTENEMYSTATE_IDLE    = 0
local SHOOTENEMYSTATE_WALKING = 1
local SHOOTENEMYSTATE_FLYING  = 2

local hurtSound = love.audio.newSource("audio/hurt.wav")

--- Initializes a enemy.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
function ShootEnemy:_init(x, y)
  GameActor:_init(x, y)

  self.type        = SHOOTENEMY_TYPE
  self.sprite      = Sprite:_init(SHOOTENEMY_IMAGE, 1, 1)
  self.box         = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.timeToShoot = Timer()
end

--- Updates the enemy object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function ShootEnemy:update(dt)
  self.sprite:update(dt)

  self.lastY = self.box.y

  self.yspeed = self.yspeed + SHOOTENEMY_GRAVITY * dt
  self.box.y = self.box.y + self.yspeed * dt

  self.box.x = self.box.x + self.xspeed * dt

  self.timeToShoot:update(dt)
  if self.timeToShoot:get() > 3 then
    self:shoot()
    self.timeToShoot:restart()
  end
end

function ShootEnemy:shoot()
  table.insert(shotEnemyBullets, SyringeBullet(self.box.x+14, self.box.y+10, 120, 180, false))
end

--- Draws the enemy object.
-- Called once once each love.draw.
function ShootEnemy:draw()
  self.sprite:draw(self.box.x, self.box.y, 0, self.facingRight)
end

--- Draws the enemy outline and collision area.
-- Called once once each love.draw if debug parameter passed.
function ShootEnemy:drawDebug()
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
function ShootEnemy:isDead()
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
function ShootEnemy:notifyCollision(other)
  if other.type == "Tile" then
    self.grounded = true
    self.yspeed = 0
    self.box.y = self.lastY
  elseif other.type == "Bullet"
  or     other.type == "Bite"
  or     other.type == "MissleBullet"
  or     other.type == "ShotgunBullet"
  or     other.type == "MachinegunBullet" then
    hurtSound:play()
    self.health = 0
  end
end

--- Specifies the type of that object.
-- @param type
-- @return boolean
function ShootEnemy:is(type)
  return type == self.type
end
