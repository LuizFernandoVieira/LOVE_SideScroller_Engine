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

local ENEMY_TYPE     = "Enemy"
local ENEMY_IMAGE    = "img/sensei/spr_boss_0.png"
local ENEMY_VELOCITY = 1
local ENEMY_HEALTH   = 1

function Enemy:_init(x, y)
  GameActor:_init(x, y)

  self.type        = ENEMY_TYPE
  self.facingRight = true
  self.velocity    = PLAYER_VELOCITY
  self.health      = PLAYER_HEALTH
  self.grounded    = false
  self.sprite      = Sprite:_init(ENEMY_IMAGE, 1, 1)
  self.box         = Rect(x, y+3, self.sprite:getWidth(), self.sprite:getHeight()-3)
end

function Enemy:update(dt)
  self.sprite:update(dt)
end

function Enemy:draw()
  self.sprite:draw(self.box.x, self.box.y, 0)
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
end

function Enemy:notifyCollision(other)
end

function Enemy:is(type)
  return type == self.type
end
