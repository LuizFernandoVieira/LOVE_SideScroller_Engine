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

local ENEMY_NAME     = "Enemy"
local ENEMY_VELOCITY = 1
local ENEMY_HEALTH   = 1

function Enemy:_init(x, y, imgPath, imgWidth, imgHeight)
  GameActor._init(self, x, y)

  self.name        = PLAYER_NAME
  self.facingRight = true
  self.velocity    = PLAYER_VELOCITY
  self.health      = PLAYER_HEALTH
  self.grounded    = false

  self.sprite = Sprite._init(self, imgPath, 1, imgWidth, imgHeight)
end

function Enemy:update(dt)
  self.sprite:update(dt)
end

function Enemy:draw()
  self.sprite:draw(self.x, self.y, self.image)
end
