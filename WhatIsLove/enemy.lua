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
local ENEMY_IMAGE        = "img/ninja/run1.png" --"img/sensei/spr_boss_0.png"
local ENEMY_VELOCITY     = 1
local ENEMY_HEALTH       = 1
local ENEMY_GRAVITY      = 800
local ENEMY_FACINGRIGHT  = true
local ENEMYSTATE_IDLE    = 0
local ENEMYSTATE_WALKING = 1

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

function Enemy:update(dt)
  self.lastY = self.box.y

  self.yspeed = self.yspeed + ENEMY_GRAVITY * dt
  self.box.y = self.box.y + self.yspeed * dt

  self.sprite:update(dt)
end

function Enemy:draw()
  self.sprite:draw(self.box.x, self.box.y, 0, self.facingRight)
end

function Enemy:drawDebug()
  love.graphics.setColor(255, 0, 0, 50)
  love.graphics.rectangle(
    "fill",
    self.box.x,
    self.box.y,
    16, 16
  )
  love.graphics.setColor(255, 0, 0)
  love.graphics.rectangle(
    "line",
    self.box.x,
    self.box.y,
    16, 16
  )
  love.graphics.setColor(255, 255, 255)
end

function Enemy:isDead()
  if self.health == 0 then
    return true
  else
    return false
  end
end

function Enemy:notifyCollision(other)
  if other.type == "Tile" then
    self.grounded = true
    self.yspeed = 0
    self.box.y = self.lastY
  elseif other.type == "Bullet" then
    self.health = 0
  end
end

function Enemy:is(type)
  return type == self.type
end
