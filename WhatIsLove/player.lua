Player         = {}
Player.__index = Player

setmetatable(Player, {
  __index = GameActor,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local PLAYER_TYPE          = "Player"
local PLAYER_IMAGE         = "img/ninja/run1.png"
local PLAYER_VELOCITY      = 1
local PLAYER_ITEMS         = 1

local PLAYERSTATE_IDLE     = 0
local PLAYERSTATE_WALKING  = 1
local PLAYERSTATE_DASHING  = 2
local PLAYERSTATE_CLIMBING = 3
local PLAYERSTATE_DEAD     = 4

local GRAVITY              = 800
local PLAYER_FACINGRIGHT   = true
local JUMP_POWER           = 255

local INFECTED_BONUS_VELOCITY   = 2.5
local INFECTED_BONUS_GRAVITY    = 3
local INFECTED_BONUS_JUMP_POWER = 2.2

function Player:_init(x, y)
  GameActor:_init(x, y)

  self.type        = PLAYER_TYPE
  self.moveUp      = false
  self.moveRight   = false
  self.moveDown    = false
  self.moveLeft    = false
  self.facingRight = PLAYER_FACINGRIGHT
  self.velocity    = PLAYER_VELOCITY
  self.items       = PLAYER_ITEMS
  self.grounded    = false
  self.state       = PLAYERSTATE_IDLE
  self.sprite      = Sprite:_init(PLAYER_IMAGE, 1, 1)
  self.box         = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.yspeed      = 0
  self.dashDuration = 0
  self.dashCooldown = 0

  self.infected    = false

  return self
end

function Player:update(dt)
  print(self.infected)

  self.sprite:update(dt)

  lastX = self.box.x
  lastY = self.box.y

  if self.moveRight and self.moveLeft then
    self.state = PLAYERSTATE_IDLE
  elseif self.moveRight then
    self.facingRight = true
    if self.infected then
      self.box.x = self.box.x + self.velocity * INFECTED_BONUS_VELOCITY
    else
      self.box.x = self.box.x + self.velocity
    end
    self.state = PLAYERSTATE_WALKING
  elseif self.moveLeft then
    self.facingRight = false
    if self.infected then
      self.box.x = self.box.x - self.velocity * INFECTED_BONUS_VELOCITY
    else
      self.box.x = self.box.x - self.velocity
    end
    self.state = PLAYERSTATE_WALKING
  else
    self.state = PLAYERSTATE_IDLE
  end

  if self.infected then
    self.yspeed = self.yspeed + GRAVITY * dt * INFECTED_BONUS_GRAVITY
  else
    self.yspeed = self.yspeed + GRAVITY * dt
  end
  self.box.y = self.box.y + self.yspeed * dt

  if(self.dashCooldown > 0) then
    self.dashCooldown = self.dashCooldown - 1
  end

  -- IDLE STATE
  if self.state == PLAYERSTATE_IDLE then
  -- WALKING STATE
  elseif self.state == PLAYERSTATE_WALKING then
  -- DASHING STATE
  elseif self.state == PLAYERSTATE_DASHING then
    self.dashDuration = self.dashDuration - dt
  -- CLIMBING STATE
  elseif self.state == PLAYERSTATE_CLIMBING then
  -- DEAD STATE
  elseif self.state == PLAYERSTATE_DEAD then
  end
end

function Player:updateIdle(dt)
end

function Player:updateWalking(dt)
end

function Player:updateClimbing(dt)
end

function Player:updateDead(dt)
end

function Player:jump()
  if self.state == PLAYERSTATE_CLIMBING then
    self:leaveLadder()
  elseif self.grounded == true then
    self.grounded = false
    if self.infected then
      self.yspeed = -JUMP_POWER * INFECTED_BONUS_JUMP_POWER
    else
      self.yspeed = -JUMP_POWER
    end
  end
end

function Player:shot()
  if self.infected then
    table.insert(bite, Bite(self.box.x-8, self.box.y-8, 32, 32))
  else
    if self.facingRight then
      table.insert(bullets, Bullet(self.box.x, self.box.y, 250, 40))
    else
      table.insert(bullets, Bullet(self.box.x, self.box.y, -250, 40))
    end
  end
end

function Player:dash()
  if self.dashCooldown <= 0 then
    print("DASH")
    self.state = PLAYERSTATE_DASHING
    self.dashCooldown = 60*1
    if self.facingRight then

    else

    end
  end
end

function Player:leaveLadder()
end

function Player:draw()
  if self.infected then
    love.graphics.setColor(100, 100, 100)
  end
  self.sprite:draw(self.box.x, self.box.y, 0, self.facingRight)
  love.graphics.setColor(255, 255, 255)
end

function Player:drawDebug()
  love.graphics.setColor(0, 200, 255, 50)
  love.graphics.rectangle(
    "fill",
    self.box.x,
    self.box.y,
    16,16
  )
  love.graphics.setColor(0, 200, 255)
  love.graphics.rectangle(
    "line",
    self.box.x,
    self.box.y,
    16,16
  )
  love.graphics.setColor(255, 255, 255)
end

function Player:isDead()
end

function Player:notifyCollision(other)
  if other.type == "Tile" then
    self.grounded = true
    self.yspeed = 0
    self.box.y = lastY
  elseif other.type == "Enemy" then
    self.infected = true
  elseif other.type == "Item" then
    self.items = self.items + 1
  end
end

function Player:is(type)
  return type == self.type
end

function Player:getName()
  return self.name
end

function Player:isMovingUp()
  return self.moveUp
end

function Player:isMovingRight()
  return self.moveRight
end

function Player:isMovingDown()
  return self.moveDown
end

function Player:isMovingLeft()
  return self.moveLeft
end

function Player:isFacingRight()
  return self.facingRight
end

function Player:getVelocity()
  return self.velocity
end

function Player:setName(name)
  self.name = name
end

function Player:setMovingUp(moveUp)
  self.moveUp = moveUp
end

function Player:setMovingRight(moveRight)
  self.moveRight = moveRight
end

function Player:setMovingDown(moveDown)
  self.moveDown = moveDown
end

function Player:setMovingLeft(moveLeft)
  self.moveLeft = moveLeft
end

function Player:setFacingRight(facingRight)
  self.facingRight = facingRight
end

function Player:setVelocity(velocity)
  self.velocity = velocity
end
