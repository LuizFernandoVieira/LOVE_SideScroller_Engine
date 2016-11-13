BlobEnemy         = {}
BlobEnemy.__index = BlobEnemy

setmetatable(BlobEnemy, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local BLOB_ENEMY_TYPE       = "BlobEnemy"
local BLOB_DOWN_ENEMY_IMAGE = "img/EnemyDriperDown.png"
local BLOB_UP_ENEMY_IMAGE   = "img/EnemyDriperUp.png"

--- Initializes a enemy.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
function BlobEnemy:_init(x, y, dir)
  Enemy:_init(x, y)

  self.type             = BLOB_ENEMY_TYPE

  if dir == nil or dir == "down" then
    self.sprite = Sprite(BLOB_DOWN_ENEMY_IMAGE, 3, 0.3)
  else
    self.sprite = Sprite(BLOB_UP_ENEMY_IMAGE, 3, 0.3)
  end

  self.box              = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.initialPosition  = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.timeUntilAttack  = Timer()
  self.dir              = dir or "down"
end

--- Updates the enemy object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function BlobEnemy:update(dt)
  self.sprite:update(dt)
  self.timeUntilAttack:update(dt)
  if self.timeUntilAttack:get() > 0.7 then
    table.insert(blobEnemyBullets, BlobEnemyBullet(self.box.x, self.box.y, self.dir, 250))
    self.timeUntilAttack:restart()
  end
end

--- Draws the enemy object.
-- Called once once each love.draw.
function BlobEnemy:draw()
  self.sprite:draw(self.box.x, self.box.y, 0, self.facingRight)
end

--- Draws the enemy outline and collision area.
-- Called once once each love.draw if debug parameter passed.
function BlobEnemy:drawDebug()
  local lg = love.graphics
  local x  = self.box.x
  local y  = self.box.y
  local w  = self.box.w
  local h  = self.box.h
  local ix = self.initialPosition.x
  lg.setColor(255, 0, 0, 50)
  lg.rectangle("fill", x, y, w, h)
  lg.setColor(255, 0, 0)
  lg.rectangle("line", x, y, w, h)
  lg.setColor(255, 255, 0, 50)
end

--- Specifies the type of that object.
-- @param type
-- @return boolean
function BlobEnemy:is(type)
  return type == self.type
end
