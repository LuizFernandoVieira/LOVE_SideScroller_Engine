Boss         = {}
Boss.__index = Boss

setmetatable(Boss, {
  __index = GameActor,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

local hurtSound            = love.audio.newSource("audio/hurt.wav")
local BOSS_TYPE            = "Boss"
local ENEMY_IMAGE          = "img/BossCarrot.png"
local ENEMY_HEALTH         = 1
local ENEMY_GRAVITY        = 800
local ENEMY_FACINGRIGHT    = true
local ENEMYSTATE_IDLE      = 0
local ENEMYSTATE_ATK_SPIKE = 1
local ENEMYSTATE_ATK_BOMB  = 2
local ENEMYSTATE_ATK_SHOOT = 3
local ENEMYSTATE_RAGE      = 4
local SPIKE_POS_IMAGE      = "img/rain.png"

--- Initializes a enemy.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
function Boss:_init(x, y)
  GameActor:_init(x, y)

  self.type             = ENEMY_TYPE
  self.facingRight      = true
  self.health           = ENEMY_HEALTH
  self.sprite           = Sprite(ENEMY_IMAGE, 1, 1)
  self.box              = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.xspeed           = 0
  self.yspeed           = 0
  self.state            = ENEMYSTATE_IDLE
  self.grounded         = false
  self.lastY            = y
  self.range            = 60
  self.bombs            = {}
  self.spikes           = {}
  self.spikesPosition   = {}
  self.createBombTime   = Timer()
  self.changeStateSpike = Timer()
  self.createSpikePos   = Timer()
  self.createSpike      = Timer()
end

--- Updates the enemy object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function Boss:update(dt)
  self.sprite:update(dt)

  self.lastY = self.box.y
  self.yspeed = self.yspeed + ENEMY_GRAVITY * dt
  self.box.y = self.box.y + self.yspeed * dt
  self.box.x = self.box.x + self.xspeed * dt

  -- IDLE STATE
  if self.state == ENEMYSTATE_IDLE then
    self:updateIdle(dt)
  -- ATK SPIKE STATE
  elseif self.state == ENEMYSTATE_ATK_SPIKE then
    self:updateAtkSpike(dt)
  -- ATK BOMB STATE
  elseif self.state == ENEMYSTATE_ATK_BOMB then
    self:updateAtkBomb(dt)
  -- ATK SHOOT STATE
  elseif self.state == ENEMYSTATE_ATK_SHOOT then
    self:updateAtkShoot(dt)
  -- BOTH
  elseif self.state == ENEMYSTATE_RAGE then
    self:updateAtkSpike(dt)
    self:updateAtkBomb(dt)
  end

  checkDead(self.spikesPosition)
  checkDead(self.spikes)

  -- print(self.changeStateSpike:get())

  self.box.x = math.floor(self.box.x)
  self.box.y = math.floor(self.box.y)
end

function checkDead(gameObject)
  local i=1
  while i <= #gameObject do
    if gameObject[i]:isDead() then
        table.remove(gameObject, i)
    else
        i = i + 1
    end
  end
end

function Boss:updateIdle(dt)
  local cx = self.box.x
  local cy = self.box.y + self.sprite:getHeight()/2
  local point = Vector(player.box.x, player.box.y)
  local circleCenter = Vector(cx, cy)
  if isCollidingPointCircle(point, circleCenter, self.range) then
    self.state = ENEMYSTATE_ATK_BOMB
  end
end

function Boss:updateAtkSpike(dt)
  self:updateBombs(dt, self.bombs)
  self:showSpikePosition(dt)
  self:updateSpikePosition(dt)
  self:createSpikes(dt, self.spikes)
  self:updateSpikes(dt)
  self.changeStateSpike:update(dt)
end

function Boss:showSpikePosition(dt)
  self.createSpikePos:update(dt)
  self.createSpike:update(dt)
  if self.createSpikePos:get() > 3 then
    local offset = math.random(7)
    table.insert(self.spikesPosition, BossSpikePos(704 + 4 + offset * 16, 166))
    local offset = math.random(7)
    table.insert(self.spikesPosition, BossSpikePos(704 + 4 + offset * 16, 166))
    local offset = math.random(7)
    table.insert(self.spikesPosition, BossSpikePos(704 + 4 + offset * 16, 166))
    local offset = math.random(7)
    table.insert(self.spikesPosition, BossSpikePos(704 + 4 + offset * 16, 166))
    self.createSpikePos:restart()
  end
end

function Boss:updateSpikePosition(dt)
  for _,v in ipairs(self.spikesPosition) do
    if isInsideCamera(v) then
      v:update(dt)
    end
  end
end

function Boss:createSpikes(dt)
  if self.createSpike:get() > 5 then
    for _,v in ipairs(self.spikesPosition) do
      table.insert(self.spikes, BossSpike(v.box.x, v.box.y - 54, 0, 200, 0))
    end
    self.createSpikePos:restart()
    self.createSpike:restart()
  end
end

function Boss:updateSpikes(dt)
  for _,v in ipairs(self.spikes) do
    if isInsideCamera(v) then
      v:update(dt)
    end
  end
end

function Boss:updateAtkBomb(dt)
  self:createBombs(dt, self.bombs)
  self:updateBombs(dt, self.bombs)
  self.changeStateSpike:update(dt)
  if self.changeStateSpike:get() > 30 then
    self.state = ENEMYSTATE_ATK_SPIKE
    self.changeStateSpike:restart()
  end
end

function Boss:createBombs(dt)
  self.createBombTime:update(dt)
  if self.createBombTime:get() > 3 then
    local offset = math.random(5)
    table.insert(self.bombs, BossBomb(702 + offset * 24, 50, 0, 300, 20))
    local offset = math.random(5)
    table.insert(self.bombs, BossBomb(702 + offset * 24, 50, 0, 300, 20))
    self.createBombTime:restart()
  end
end

function Boss:updateBombs(dt)
  for _,v in ipairs(self.bombs) do
    if isInsideCamera(v) then
      v:update(dt)
    end
  end
  if self.changeStateSpike:get() > 30 then
    self.state = ENEMYSTATE_RAGE
    self.changeStateSpike:restart()
    self.createBombTime:restart()
    self.createSpikePos:restart()
    self.createSpike:restart()
  end
end

function Boss:updateAtkShoot(dt)
  -- print("shoot")
end

--- Draws the enemy object.
-- Called once once each love.draw.
function Boss:draw()
  self.sprite:draw(self.box.x, self.box.y, 0, self.facingRight)
  for _,v in ipairs(self.bombs) do
    v:draw()
  end
  for _,v in ipairs(self.spikesPosition) do
    v:draw()
  end
  for _,v in ipairs(self.spikes) do
    v:draw()
  end
end

--- Draws the enemy outline and collision area.
-- Called once once each love.draw if debug parameter passed.
function Boss:drawDebug()
  local lg = love.graphics
  local x  = self.box.x
  local y  = self.box.y
  local w  = self.box.w
  local h  = self.box.h
  local cx = self.box.x + self.sprite:getWidth()/2
  local cy = self.box.y + self.sprite:getHeight()/2
  lg.setColor(255, 0, 0, 50)
  lg.rectangle("fill", x, y, w, h)
  lg.setColor(255, 0, 0)
  lg.rectangle("line", x, y, w, h)
  lg.setColor(255, 255, 0, 50)
  lg.circle("fill", cx, cy, self.range, 100)
  lg.setColor(255, 255, 0)
  lg.circle("line", cx, cy, self.range, 100)
  lg.setColor(255, 255, 255)
  for _,v in ipairs(self.bombs) do
    v:drawDebug()
  end
  for _,v in ipairs(self.spikesPosition) do
    v:drawDebug()
  end
  for _,v in ipairs(self.spikes) do
    v:drawDebug()
  end
end

--- Check if enemy still have health.
-- If not it should be destroyed.
-- @return boolean
function Boss:isDead()
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
function Boss:notifyCollision(other)
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
function Boss:is(type)
  return type == self.type
end
