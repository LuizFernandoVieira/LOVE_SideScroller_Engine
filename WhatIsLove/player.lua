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

local PLAYER_TYPE               = "Player"

local PLAYER_ANIM_IDLE          = "img/PlayerNormal_Idle.png"
local PLAYER_ANIM_INF_IDLE      = "img/PlayerAngry_Idle.png"
local PLAYER_ANIM_WALKING       = "img/PlayerNormal_Walking.png"
local PLAYER_ANIM_INF_WALKING   = "img/PlayerAngry_Walking.png"
local PLAYER_ANIM_JUMPING       = "img/PlayerNormal_Jupming.png"
local PLAYER_ANIM_INF_JUMPING   = "img/PlayerAngry_Jumping.png"
local PLAYER_ANIM_DYING         = "img/PlayerNormal_Idle.png"
local PLAYER_ANIM_INF_DYING     = "img/PlayerAngry_Idle.png"

local PLAYER_GUN_ANIM           = "img/GunPistol.png"
local PLAYER_MACHINEGUN_ANIM    = "img/GunMachinegun.png"
local PLAYER_SHOTGUN_ANIM       = "img/GunShotgun.png"
local PLAYER_MISSLEGUN_ANIM     = "img/GunMisselLaucher.png"

local PLAYER_VELOCITY           = 1
local PLAYER_ITEMS              = 1

local PLAYERSTATE_IDLE          = 0
local PLAYERSTATE_WALKING       = 1
local PLAYERSTATE_DASHING       = 2
local PLAYERSTATE_CLIMBING      = 3
local PLAYERSTATE_DEAD          = 4
local PLAYERSTATE_JUMPING       = 5

local PLAYERWEAPON_GUN          = 0
local PLAYERWEAPON_SHOTGUN      = 1
local PLAYERWEAPON_MISSLEGUN    = 2
local PLAYERWEAPON_MACHINEGUN   = 3

local GRAVITY                   = 800
local PLAYER_FACINGRIGHT        = true
local JUMP_POWER                = 255

local INFECTED_BONUS_VELOCITY   = 2.5
local INFECTED_BONUS_GRAVITY    = 3
local INFECTED_BONUS_JUMP_POWER = 2.2

--- Initializes player.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
function Player:_init(x, y)
  GameActor:_init(x, y)

  self.type            = PLAYER_TYPE
  self.moveUp          = false
  self.moveRight       = false
  self.moveDown        = false
  self.moveLeft        = false
  self.facingRight     = PLAYER_FACINGRIGHT
  self.velocity        = PLAYER_VELOCITY
  self.items           = PLAYER_ITEMS
  self.grounded        = false
  self.state           = PLAYERSTATE_IDLE
  self.xspeed          = 0
  self.yspeed          = 0
  self.dashDuration    = 0
  self.dashCooldown    = 0
  self.canClimb        = false
  self.infected        = false
  self.weapon          = PLAYERWEAPON_GUN
  self.shotgunCooldown = 0
  self.dmgCooldown     = 0
  self.respawnTime     = 3

  self.animIdle            = Sprite:_init(PLAYER_ANIM_IDLE       , 1, 1   )
  self.animIdleInfected    = Sprite:_init(PLAYER_ANIM_INF_IDLE   , 1, 1   )
  self.animWalking         = Sprite:_init(PLAYER_ANIM_WALKING    , 8, 0.1)
  self.animWalkingInfected = Sprite:_init(PLAYER_ANIM_INF_WALKING, 3, 0.15)
  self.animJumping         = Sprite:_init(PLAYER_ANIM_JUMPING    , 1, 1   )
  self.animJumpingInfected = Sprite:_init(PLAYER_ANIM_INF_JUMPING, 1, 1   )
  self.animFalling         = Sprite:_init(PLAYER_ANIM_IDLE       , 1, 1   )
  self.animFallingInfected = Sprite:_init(PLAYER_ANIM_INF_IDLE   , 1, 1   )
  self.animDying           = Sprite:_init(PLAYER_ANIM_DYING      , 1, 1   )
  self.animDyingInfected   = Sprite:_init(PLAYER_ANIM_INF_DYING  , 1, 1   )
  self.sprite              = self.animIdle

  self.animGun        = Sprite:_init(PLAYER_GUN_ANIM       , 1, 1)
  self.animMachinegun = Sprite:_init(PLAYER_MACHINEGUN_ANIM, 1, 1)
  self.animShotgun    = Sprite:_init(PLAYER_SHOTGUN_ANIM   , 1, 1)
  self.animMisslegun  = Sprite:_init(PLAYER_MISSLEGUN_ANIM , 1, 1)
  self.gunSprite      = self.animGun

  self.boxIdle            = Rect(x, y, self.animIdle:getWidth(), self.animIdle:getHeight())
  self.boxIdleInfected    = Rect(x, y, self.animIdleInfected:getWidth(), self.animIdleInfected:getHeight())
  self.boxWalking         = Rect(x, y, self.animIdle:getWidth(), self.animIdle:getHeight())
  self.boxWalkingInfected = Rect(x, y, self.animIdleInfected:getWidth(), self.animIdleInfected:getHeight())
  self.boxJumping         = Rect(x, y, self.animIdle:getWidth(), self.animIdle:getHeight())
  self.boxJumpingInfected = Rect(x, y, self.animIdleInfected:getWidth(), self.animIdleInfected:getHeight())
  self.boxFalling         = Rect(x, y, self.animIdle:getWidth(), self.animIdle:getHeight())
  self.boxFallingInfected = Rect(x, y, self.animIdleInfected:getWidth(), self.animIdleInfected:getHeight())
  self.boxDying           = Rect(x, y, self.animDying:getWidth(), self.animDying:getHeight())
  self.boxDyingInfected   = Rect(x, y, self.animDyingInfected:getWidth(), self.animDyingInfected:getHeight())
  self.box                = self.boxIdle

  return self
end

--- Updates the player object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function Player:update(dt)
  self.sprite:update(dt)

  lastX = self.box.x
  lastY = self.box.y

  -- print("dcd: " .. self.dmgCooldown)

  if self.state ~= PLAYERSTATE_DEAD then
    self.dmgCooldown = self.dmgCooldown - dt
  end

  -- IDLE STATE
  if self.state == PLAYERSTATE_IDLE then
    self:updateWalking(dt)
    self:updateGravity(dt)
    self:checkIfStartedClimbing(dt)
  -- WALKING STATE
  elseif self.state == PLAYERSTATE_WALKING then
    self:updateGravity(dt)
    self:updateWalking(dt)
    self:checkIfStartedClimbing(dt)
  -- DASHING STATE
  elseif self.state == PLAYERSTATE_DASHING then
    self:updateDashing(dt)
  -- CLIMBING STATE
  elseif self.state == PLAYERSTATE_CLIMBING then
    self:updateClimbing(dt)
  -- DEAD STATE
  elseif self.state == PLAYERSTATE_DEAD then
    self:updateDead(dt)
  elseif self.state == PLAYERSTATE_JUMPING then
    self:updateWalking(dt)
    self:updateGravity(dt)
  end

  self.box.x = math.floor(self.box.x)
  self.box.y = math.floor(self.box.y)
end

--- Updates the player object when his state is idle.
-- @param dt Time passed since last update
function Player:updateIdle(dt)
end

--- Updates the player object when his state is walking.
-- @param dt Time passed since last update
function Player:updateWalking(dt)
  -- clica para esquerda e direita
  if self.moveRight and self.moveLeft then
    if self.state ~= PLAYERSTATE_JUMPING then
      self.state = PLAYERSTATE_IDLE
      if self.infected then
        self.sprite = self.animIdleInfected
      else
        self.sprite = self.animIdle
      end
    end
  -- clica para direita
  elseif self.moveRight then
    self.facingRight = true
    -- jumping
    if self.state == PLAYERSTATE_JUMPING then
      if self.infected then
        self.box.x = self.box.x + self.velocity * INFECTED_BONUS_VELOCITY
      else
        local vel = handleCollision(self.box.x, self.box.y, self.velocity, dt)
        self.box.x = self.box.x + vel
      end
    -- not jumping
    else
      if self.infected then
        self.sprite = self.animWalkingInfected
        self.box.x = self.box.x + self.velocity * INFECTED_BONUS_VELOCITY
      else
        self.sprite = self.animWalking
        local vel = handleCollision(self.box.x, self.box.y, self.velocity, dt)
        self.box.x = self.box.x + vel
      end
      self.state = PLAYERSTATE_WALKING
    end
  -- clica para esquerda
  elseif self.moveLeft then
    self.facingRight = false
    -- jumping
    if self.state == PLAYERSTATE_JUMPING then
      if self.infected then
        self.box.x = self.box.x - self.velocity * INFECTED_BONUS_VELOCITY
      else
        local vel = handleCollision(self.box.x, self.box.y, self.velocity, dt)
        self.box.x = self.box.x - vel
      end
    -- not jumping
    else
      if self.state ~= PLAYERSTATE_JUMPING then
        if self.infected then
          self.sprite = self.animWalkingInfected
          self.box.x = self.box.x - self.velocity * INFECTED_BONUS_VELOCITY
        else
          self.sprite = self.animWalking
          local vel = handleCollision(self.box.x, self.box.y, self.velocity, dt)
          self.box.x = self.box.x - vel
        end
        self.state = PLAYERSTATE_WALKING
      end
    end
  -- nao clica nada
  else
    if self.state ~= PLAYERSTATE_JUMPING then
      self.state = PLAYERSTATE_IDLE
      if self.infected then
        self.sprite = self.animIdleInfected
      else
        self.sprite = self.animIdle
      end
    end
  end
end

--- Updates the player object when he is not climbing.
-- @param dt Time passed since last update
function Player:updateGravity(dt)
  if self.infected then
    self.yspeed = self.yspeed + GRAVITY * dt * INFECTED_BONUS_GRAVITY
  else
    self.yspeed = self.yspeed + GRAVITY * dt
  end
  self.box.y = self.box.y + self.yspeed * dt
end

--- Updates the player object when his state is dashing.
-- @param dt Time passed since last update
function Player:updateDashing(dt)
  self.dashCooldown = self.dashCooldown - dt * 200
  self.box.x = self.box.x + self.xspeed * dt*5

  if self.dashCooldown <= 0 then
    self.dashCooldown = 0
    self.state = PLAYERSTATE_IDLE
  end
end

--- Checks if the player started climbing.
-- @param dt Time passed since last update
function Player:checkIfStartedClimbing(dt)
  if self.moveUp then
    for i,v in ipairs(ladders) do
      if isColliding(player.box, v.box, player.rotation, v.rotation) then
        self.state = PLAYERSTATE_CLIMBING
      end
    end
  end
end

--- Updates the player when his state is climbing.
-- @param dt Time passed since last update
function Player:updateClimbing(dt)
  if self.moveUp then
    self.box.y = self.box.y - 2
  elseif self.moveDown then
    self.box.y = self.box.y + 2
  end

  -- logica de sair da escada

  -- if not joystick then return
  if love.keyboard.isDown('space') then
    self:jump()
  end
end

--- Updates the player when his state is dead.
-- @param dt Time passed since last update
function Player:updateDead(dt)
  self.respawnTime = self.respawnTime - 0.02
  self:updateGravity(dt)

  if self.respawnTime <= 0 then
    self.infected = false
    self.sprite = self.animIdle
    self.boxIdle.x = self.box.x
    self.boxIdle.y = self.box.y
    self.box = self.boxIdle
    self.respawnTime = 3
    self.state = PLAYERSTATE_IDLE
  end
end

--- Apply impulse in the y axis.
-- Player can't jump on air.
function Player:jump()
  if player.state == PLAYERSTATE_DEAD then
    return
  end

  jumpSound:play()

  if self.state == PLAYERSTATE_CLIMBING then
    self:leaveLadder()
  elseif self.grounded == true then
    self.state = PLAYERSTATE_JUMPING
    self.grounded = false
    if self.infected then
      self.sprite = self.animJumpingInfected
      self.yspeed = -JUMP_POWER * INFECTED_BONUS_JUMP_POWER
    else
      self.sprite = self.animJumping
      self.yspeed = -JUMP_POWER
    end
  end
end

--- Fires a projectile depending on the
-- current weapon that the player is using.
function Player:shot()
  local x = self.box.x
  local y = self.box.y

  if self.infected then
    if self.facingRight then
      table.insert(bite, Bite(x+16, y+5, 32, 32, self.facingRight))
    else
      table.insert(bite, Bite(x-16, y+5, 32, 32, self.facingRight))
    end
  else
    shotSound:play()
    -- Gun
    if self.weapon == PLAYERWEAPON_GUN then
      if self.facingRight then
        table.insert(bullets, Bullet(x, y+7, 250, 10000))
      else
        table.insert(bullets, Bullet(x-5, y+7, -250, 10000))
      end
    -- Shotgun
    elseif self.weapon == PLAYERWEAPON_SHOTGUN then
      if self.shotgunCooldown <= 0 then
        self.shotgunCooldown = 0.3
        if self.facingRight then
          table.insert(bullets, Bullet(x, y+7, 250, 10000))
        else
          table.insert(bullets, Bullet(x-5, y+7, -250, 10000))
        end
      else
        self.shotgunCooldown = self.shotgunCooldown - 0.05
      end
    -- Misslegun
    elseif self.weapon == PLAYERWEAPON_MISSLEGUN then
      if self.facingRight then
        table.insert(missleBullets, MissleBullet(x, y+7, 250, 100))
      else
        table.insert(missleBullets, MissleBullet(x-5, y+7, -250, 100))
      end
    -- Machinegun
    elseif self.weapon ==  PLAYERWEAPON_MACHINEGUN then
      if self.facingRight then
        table.insert(bullets, Bullet(x, y, 150, 50, -40))
        table.insert(bullets, Bullet(x, y, 150, 50, 0))
        table.insert(bullets, Bullet(x, y, 150, 50, 40))
      else
        table.insert(bullets, Bullet(x, y, -150, 50, -40))
        table.insert(bullets, Bullet(x, y, -150, 50, 0))
        table.insert(bullets, Bullet(x, y, -150, 50, 40))
      end
    end
  end
end

--- Apply impulse in the x axis.
-- You lose control of the player for
-- the full duration of the dash.
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

--- Makes the player leave the ladder.
function Player:leaveLadder()
end

--- Draws the player object.
-- Called once once each love.draw.
function Player:draw()
  self.gunSprite:draw(self.box.x, self.box.y, 0, self.facingRight)
  self.sprite:draw(self.box.x, self.box.y, 0, self.facingRight)
end

--- Draws the player outline and collision area.
-- Called once once each love.draw if debug parameter passed.
function Player:drawDebug()
  local lg = love.graphics
  local x  = self.box.x
  local y  = self.box.y
  local w  = self.sprite:getWidth()
  local h  = self.sprite:getHeight()
  lg.setColor(0, 200, 255, 50)
  lg.rectangle("fill", x, y, w, h)
  lg.setColor(0, 200, 255)
  lg.rectangle("line", x, y, w, h)
  lg.setColor(255, 255, 255)
end

--- Checks if player health is more than zero.
-- @return boolean
function Player:isDead()
end

--- Checks horizontal collision
-- @param player
-- @param other
-- @return boolean
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

--- Notifies the player that a collision involving himself had ocurred.
-- The player (subject) had previously subscribed
-- to the collision system (observer).
-- @param other
function Player:notifyCollision(other)
  if other.type == "Tile" then
    -- se colidiu verticalmente
    self.grounded = true
    self.yspeed = 0
    self.box.y = lastY
    self.state = PLAYERSTATE_IDLE
    -- se colidiu horizontalmente
    -- if  then
    --   self.box.x = lastX
    -- end
  elseif other.type == "Enemy" then
    if self.dmgCooldown <= 0 then
      if not self.infected then
        self.dmgCooldown = 3
        self.infected = true
        self.sprite = self.animIdleInfected
        self.boxIdleInfected.x = self.box.x
        self.boxIdleInfected.y = self.box.y
        self.box = self.boxIdleInfected
      elseif self.infected then
        self.sprite = self.animDyingInfected
        self.boxDyingInfected.x = self.box.x
        self.boxDyingInfected.y = self.box.y
        self.box = self.boxDyingInfected
        self.state = PLAYERSTATE_DEAD
      end
    end
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
  elseif other.type == "Gun" then
    self.weapon = PLAYERWEAPON_GUN
    self.gunSprite = self.animGun
  elseif other.type == "Shotgun" then
    self.weapon = PLAYERWEAPON_SHOTGUN
    self.gunSprite = self.animShotgun
  elseif other.type == "Misslegun" then
    self.weapon = PLAYERWEAPON_MISSLEGUN
    self.gunSprite = self.animMisslegun
  elseif other.type == "Machinegun" then
    self.weapon = PLAYERWEAPON_MACHINEGUN
    self.gunSprite = self.animMachinegun
  end
end

--- Specifies the type of that object.
-- @param type
-- @return boolean
function Player:is(type)
  return type == self.type
end

--- Gets player name.
-- @return string
function Player:getName()
  return self.name
end

--- Gets if the player is moving up.
-- @return boolean
function Player:isMovingUp()
  return self.moveUp
end

--- Gets if the player is moving right.
-- @return boolean
function Player:isMovingRight()
  return self.moveRight
end

--- Gets if the playeris moving down.
-- @return boolean
function Player:isMovingDown()
  return self.moveDown
end

--- Gets if the player is moving left.
-- @return boolean
function Player:isMovingLeft()
  return self.moveLeft
end

--- Gets if the player is facing right.
-- @return boolean
function Player:isFacingRight()
  return self.facingRight
end

--- Gets player velocity.
-- @return number
function Player:getVelocity()
  return self.velocity
end

--- Sets the player name
-- @param name
function Player:setName(name)
  self.name = name
end

--- Sets the player moveUp
-- @param moveUp
function Player:setMovingUp(moveUp)
  self.moveUp = moveUp
end

--- Sets the player moveRight
-- @param moveRight
function Player:setMovingRight(moveRight)
  self.moveRight = moveRight
end

--- Sets the player moveDown
-- @param moveDown
function Player:setMovingDown(moveDown)
  self.moveDown = moveDown
end

--- Sets the player moveLeft
-- @param moveLeft
function Player:setMovingLeft(moveLeft)
  self.moveLeft = moveLeft
end

--- Sets the player facingRight
-- @param facingRight
function Player:setFacingRight(facingRight)
  self.facingRight = facingRight
end

--- Sets the player velocity
-- @param velocity
function Player:setVelocity(velocity)
  self.velocity = velocity
end
