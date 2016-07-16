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

local PLAYER_NAME     = "Player"
local PLAYER_VELOCITY = 1
local PLAYER_HEALTH   = 1

local PLAYERSTATE_IDLE    = 0
local PLAYERSTATE_WALKING = 1
local PLAYERSTATE_RUNNING = 2

function Player:_init(x, y, imgPath, imgWidth, imgHeight)
  GameActor._init(self, x, y)

  self.name        = PLAYER_NAME
  self.moveUp      = false
  self.moveRight   = false
  self.moveDown    = false
  self.moveLeft    = false
  self.facingRight = true
  self.velocity    = PLAYER_VELOCITY
  self.health      = PLAYER_HEALTH
  self.grounded    = false

  self.sprite = Sprite._init(self, imgPath, 1, imgWidth, imgHeight)
end

function Player:update(dt)
  self.sprite:update(dt)

  if self.moveUp then
    self.y = self.y - self.velocity
  end
  if self.moveRight then
    self.x = self.x + self.velocity
  end
  if self.moveDown then
    self.y = self.y + self.velocity
  end
  if self.moveLeft then
    self.x = self.x - self.velocity
  end
end

function Player:draw()
  self.sprite:draw(self.x, self.y, self.image)
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
