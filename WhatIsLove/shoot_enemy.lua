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
local SHOOTENEMY_IMAGE        = "img/enemy_fox.png"
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
  Enemy:_init(x, y)

  self.type        = SHOOTENEMY_TYPE
  self.sprite      = Sprite(SHOOTENEMY_IMAGE, 1, 1)
  self.box         = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.timeToShoot = Timer()
end

--- Updates the enemy object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function ShootEnemy:update(dt)
  Enemy.update(self, dt)

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

--- Specifies the type of that object.
-- @param type
-- @return boolean
function ShootEnemy:is(type)
  return type == self.type
end
