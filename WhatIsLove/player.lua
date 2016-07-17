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
local PLAYER_HEALTH        = 1
local PLAYERSTATE_IDLE     = 0
local PLAYERSTATE_WALKING  = 1
local PLAYERSTATE_CLIMBING = 2
local PLAYERSTATE_DEAD     = 3
local GRAVITY              = 350
local PLAYER_FACINGRIGHT   = true

function Player:_init(x, y)
  GameActor:_init(x, y)

  self.type        = PLAYER_TYPE
  self.moveUp      = false
  self.moveRight   = false
  self.moveDown    = false
  self.moveLeft    = false
  self.facingRight = PLAYER_FACINGRIGHT
  self.velocity    = PLAYER_VELOCITY
  self.health      = PLAYER_HEALTH
  self.grounded    = false
  self.state       = PLAYERSTATE_IDLE
  self.grounded    = false
  self.sprite      = Sprite:_init(PLAYER_IMAGE, 1, 1)
  self.box         = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
end

function Player:update(dt)
  self.sprite:update(dt)

  if self.moveRight and self.moveLeft then
    self.state = PLAYERSTATE_IDLE
  elseif self.moveRight then
    self.box.x = self.box.x + self.velocity
    self.state = PLAYERSTATE_WALKING
  elseif self.moveLeft then
    self.box.x = self.box.x - self.velocity
    self.state = PLAYERSTATE_WALKING
  else
    self.state = PLAYERSTATE_IDLE
  end

  if not self.grounded then
    self.box.y = self.box.y + GRAVITY*dt
  end

  -- IDLE STATE
  if self.state == PLAYERSTATE_IDLE then
  -- WALKING STATE
  elseif self.state == PLAYERSTATE_WALKING then
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
    -- pula
  end
end

function Player:leaveLadder()
end

function Player:draw()
  self.sprite:draw(self.box.x, self.box.y, 0)
end

function Player:isDead()
end

function Player:notifyCollision(other)
  if other.name == "Tile" then
    print("colidiu com tile")
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

function Player:getHealth()
  return self.health
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

function Player:getHealth(health)
  self.health = health
end