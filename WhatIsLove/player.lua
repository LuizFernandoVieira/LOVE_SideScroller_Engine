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
local PLAYER_ANIM_IDLE     = "img/Player_NormalV2.png"
local PLAYER_ANIM_INF_IDLE = "img/Player_RaivosoV2.png"
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

  self.type         = PLAYER_TYPE
  self.moveUp       = false
  self.moveRight    = false
  self.moveDown     = false
  self.moveLeft     = false
  self.facingRight  = PLAYER_FACINGRIGHT
  self.velocity     = PLAYER_VELOCITY
  self.items        = PLAYER_ITEMS
  self.grounded     = false
  self.state        = PLAYERSTATE_IDLE
  self.xspeed       = 0
  self.yspeed       = 0
  self.dashDuration = 0
  self.dashCooldown = 0
  self.canClimb     = false
  self.infected     = false

  self.animIdle            = Sprite:_init(PLAYER_ANIM_IDLE, 1, 1)
  self.animIdleInfected    = Sprite:_init(PLAYER_ANIM_INF_IDLE, 1, 1)
  self.animWalking         = Sprite:_init(PLAYER_ANIM_IDLE, 1, 1)
  self.animWalkingInfected = Sprite:_init(PLAYER_ANIM_INF_IDLE, 1, 1)
  self.animJumping         = Sprite:_init(PLAYER_ANIM_IDLE, 1, 1)
  self.animJumpingInfected = Sprite:_init(PLAYER_ANIM_INF_IDLE, 1, 1)
  self.animFalling         = Sprite:_init(PLAYER_ANIM_IDLE, 1, 1)
  self.animFallingInfected = Sprite:_init(PLAYER_ANIM_INF_IDLE, 1, 1)
  self.sprite              = self.animIdle

  self.boxIdle            = Rect(x, y, self.animIdle:getWidth(), self.animIdle:getHeight())
  self.boxIdleInfected    = Rect(x, y, self.animIdleInfected:getWidth(), self.animIdleInfected:getHeight())
  self.boxWalking         = Rect(x, y, self.animIdle:getWidth(), self.animIdle:getHeight())
  self.boxWalkingInfected = Rect(x, y, self.animIdleInfected:getWidth(), self.animIdleInfected:getHeight())
  self.boxJumping         = Rect(x, y, self.animIdle:getWidth(), self.animIdle:getHeight())
  self.boxJumpingInfected = Rect(x, y, self.animIdleInfected:getWidth(), self.animIdleInfected:getHeight())
  self.boxFalling         = Rect(x, y, self.animIdle:getWidth(), self.animIdle:getHeight())
  self.boxFallingInfected = Rect(x, y, self.animIdleInfected:getWidth(), self.animIdleInfected:getHeight())
  self.box                = self.boxIdle

  return self
end

function Player:update(dt)
  self.sprite:update(dt)

  lastX = self.box.x
  lastY = self.box.y

  -- IDLE STATE
  if self.state == PLAYERSTATE_IDLE then
    self:updateWalking(dt)
    self:updateGravity(dt)
    self:checkIfStartedClimbing(dt)
  -- WALKING STATE
  elseif self.state == PLAYERSTATE_WALKING then
    self:updateWalking(dt)
    self:updateGravity(dt)
    self:checkIfStartedClimbing(dt)
  -- DASHING STATE
  elseif self.state == PLAYERSTATE_DASHING then
    self:updateDashing(dt)
  -- CLIMBING STATE
  elseif self.state == PLAYERSTATE_CLIMBING then
    self:updateClimbing(dt)
  -- DEAD STATE
  elseif self.state == PLAYERSTATE_DEAD then
  end
end

function Player:updateIdle(dt)
end

function Player:updateWalking(dt)
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
end

function Player:updateGravity(dt)
  if self.infected then
    self.yspeed = self.yspeed + GRAVITY * dt * INFECTED_BONUS_GRAVITY
  else
    self.yspeed = self.yspeed + GRAVITY * dt
  end
  self.box.y = self.box.y + self.yspeed * dt
end

function Player:updateDashing(dt)
  self.dashCooldown = self.dashCooldown - dt * 200
  self.box.x = self.box.x + self.xspeed * dt*5

  if self.dashCooldown <= 0 then
    self.dashCooldown = 0
    self.state = PLAYERSTATE_IDLE
  end
end

function Player:checkIfStartedClimbing(dt)
  if self.moveUp then
    for i,v in ipairs(ladders) do
      if isColliding(player.box, v.box, player.rotation, v.rotation) then
        self.state = PLAYERSTATE_CLIMBING
      end
    end
  end
end

function Player:updateClimbing(dt)
  if self.moveUp then
    self.box.y = self.box.y - 2
  elseif self.moveDown then
    self.box.y = self.box.y + 2
  end

  -- if not joystick then return
  if love.keyboard.isDown('space') then
    self:jump()
  end
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
    self.state = PLAYERSTATE_DASHING
    self.dashCooldown = 60*1
    if self.facingRight then
      self.xspeed = 30
    else
      self.xspeed = -30
    end
  end
end

function Player:leaveLadder()
end

function Player:draw()
  self.sprite:draw(self.box.x, self.box.y, 0, self.facingRight)
end

function Player:drawDebug()
  love.graphics.setColor(0, 200, 255, 50)
  love.graphics.rectangle(
    "fill",
    self.box.x,
    self.box.y,
    self.box.w,
    self.box.h
  )
  love.graphics.setColor(0, 200, 255)
  love.graphics.rectangle(
    "line",
    self.box.x,
    self.box.y,
    self.box.w,
    self.box.h
  )
  love.graphics.setColor(255, 255, 255)
end

function Player:isDead()
end

function colidiuHorizontalmente(player, other)
  local playerMaxRight = player.box.x + player.sprite:getWidth()
  local otherMaxRight = other.box.x + 16
  if playerMaxRight > other.box.x
  and player.moveRight then
    return true
  -- elseif player.box:center().x > other.box:center().x
  -- and player.moveLeft then
  --   return true
  end
  return false
end

function Player:notifyCollision(other)
  if other.type == "Tile" then

    -- se colidiu verticalmente
    self.grounded = true
    self.yspeed = 0
    self.box.y = lastY

    -- se colidiu horizontalmente
    -- if  then
    --   self.box.x = lastX
    -- end

  elseif other.type == "Enemy" then
    self.infected = true
    self.sprite = self.animIdleInfected
    self.boxIdleInfected.x = self.box.x
    self.boxIdleInfected.y = self.box.y
    self.box = self.boxIdleInfected
  elseif other.type == "Antidote" then
    self.infected = false
    self.sprite = self.animIdle
    self.boxIdle.x = self.box.x
    self.boxIdle.y = self.box.y
    self.box = self.boxIdle
  elseif other.type == "Item" then
    self.items = self.items + 1
  elseif other.type == "Ladder" then
    self.canClimb = true
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
