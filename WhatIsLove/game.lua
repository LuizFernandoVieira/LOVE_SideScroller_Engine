player        = {}
tiles         = {}
map           = {}
enemies       = {}
items         = {}
particles     = {}
bullets       = {}
missleBullets = {}
bite          = {}
ladders       = {}
weapons       = {}

chaseEnemies     = {}
rightLeftEnemies = {}

psystem = {}
mobileCntrl = love.graphics.newImage("img/mobile_cntrl.png")
sound = love.audio.newSource("audio/teste.mp3")

--- Initializes objects that belong to the first level.
-- Called once on game state change.
function gameState:init()
  currentGameState = "gameState"

  player = Player:_init(132, 116)
  camera = Camera(player.box.x, player.box.y)

  loadEnemies()
  loadItems()
  loadBackgroundObjects()
  loadAudio()

  map = Map:_init()
end

--- Initializes enemies.
function loadEnemies()
  table.insert(enemies, Enemy(70, 0))
  table.insert(enemies, Enemy(150, 0))
  table.insert(enemies, Enemy(200, 0))
  table.insert(chaseEnemies, ChaseEnemy(250, 0))
  table.insert(rightLeftEnemies, RightLeftEnemy(300, 0))
end

--- Initializes items.
function loadItems()
  table.insert(items, Item(20, 150))
  table.insert(items, Item(0, 150))
  table.insert(items, Antidote(110, 150))
  table.insert(ladders, Ladder(230, 100))
  table.insert(weapons, Gun(50, 100))
  table.insert(weapons, Shotgun(100, 100))
  table.insert(weapons, Misslegun(150, 100))
end

-- Initializes background objects.
function loadBackgroundObjects()
end

--- Initializes audio.
function loadAudio()
  -- sound:play()
end

--- Initializes particles.
function loadParticles()
  local img = love.graphics.newImage('img/rain.png')
  psystem = love.graphics.newParticleSystem(img, 32)
  psystem:setParticleLifetime(2, 5)
  psystem:setEmissionRate(50)
  psystem:setSizeVariation(1)
  psystem:setLinearAcceleration(-1000, 0, 1000, 1000)
end

--- Updates all entities that belong to the first level.
-- Called once once each love.update.
-- @param dt Time passed since last update
function gameState:update(dt)
  handleInputs()
  player:update(dt)

  local dx = player.box.x - camera.x
  local dy = player.box.y - camera.y
  camera:move(dx/2, dy/2)

  -- psystem:update(dt)

  updateGameObjects(dt, enemies)
  updateGameObjects(dt, chaseEnemies)
  updateGameObjects(dt, rightLeftEnemies)
  updateGameObjects(dt, items)
  updateGameObjects(dt, bullets)
  updateGameObjects(dt, missleBullets)
  updateGameObjects(dt, ladders)
  updateGameObjects(dt, weapons)
  updateGameObjects(dt, bite)
  checkCollision()
  deleteDeadEntities()
end

--- Updates gameObjects passed as a parameter.
-- Called each love.update for each entity type.
-- @param dt Time passed since last update
-- @param gameObjects List of game objects
function updateGameObjects(dt, gameObjects)
  for _,v in ipairs(gameObjects) do
    v:update(dt)
  end
end

--- Deletes entities marked as dead.
function deleteDeadEntities()
  deleteDead(enemies)
  deleteDead(chaseEnemies)
  deleteDead(chaseEnemies)
  deleteDead(items)
  -- deleteDead(bite)
  deleteDead(weapons)
end

--- Delete game object if that object is dead.
-- @param gameObject A game object
function deleteDead(gameObject)
  local i=1
  while i <= #gameObject do
    if gameObject[i]:isDead() then
        table.remove(gameObject, i)
    else
        i = i + 1
    end
  end
end

--- Captures all inputs that depend on the user pressing a key.
-- Called once once each love.update.
function handleInputs()
  local lk = love.keyboard

  if lk.isDown('w') then player:setMovingUp(true)    end
  if lk.isDown('d') then player:setMovingRight(true) end
  if lk.isDown('s') then player:setMovingDown(true)  end
  if lk.isDown('a') then player:setMovingLeft(true)  end

  if lk.isDown("space") then
    if player.weapon == 1 then
      player:shot()
    end
  end

  if not joystick then return end
  if joystick:isGamepadDown("dpup") then
    player:setMovingUp(true)
  elseif joystick:isGamepadDown("dpright") or
         joystick:getGamepadAxis("leftx") > 0.2 then
    player:setMovingRight(true)
  elseif joystick:isGamepadDown("dpdown") then
    player:setMovingDown(true)
  elseif joystick:isGamepadDown("dpleft") or
         joystick:getGamepadAxis("leftx") < -0.2 then
    player:setMovingLeft(true)
  end

  if joystick:isGamepadDown("x") then
    if player.weapon == 1 then
      player:shot()
    end
  end
end

--- Draws all game objects that belong to the first level.
-- Called once once each love.draw.
function gameState:draw()
  camera:attach(config.scale)

  love.graphics.setBackgroundColor(255, 255, 255)
  love.graphics.draw(tilesetBatch)

  drawGameObjects(enemies)
  drawGameObjects(chaseEnemies)
  drawGameObjects(rightLeftEnemies)
  drawGameObjects(items)
  drawGameObjects(ladders)
  drawGameObjects(bullets)
  drawGameObjects(missleBullets)
  drawGameObjects(bite)
  drawGameObjects(weapons)

  player:draw()

  drawDebug()

  camera:detach()

  -- love.graphics.draw(psystem, love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5)

  if love.system.getOS() == "Android" then
    local touches = love.touch.getTouches()
    for i, id in ipairs(touches) do
        local x, y = love.touch.getPosition(id)
        local lg = love.graphics
        lg.setColor(0, 255, 0)
        lg.circle("fill", x, y, 20)
        lg.setColor(255, 255, 255)
    end
      drawMobileControler()
  end

  love.graphics.push()
  setZoom()
  love.graphics.scale(config.scale)

  drawHUD()

  love.graphics.pop()
  love.graphics.setScissor()
end

--- Draws game objects received as parameter.
-- Called one for each type of object.
-- @param gameObjects List of game objects
function drawGameObjects(gameObjects)
  for _,v in ipairs(gameObjects) do
    v:draw()
  end
end

--- Draws all game objects outline and collision area.
-- Called once once each love.draw if debug parameter passed.
function drawDebug()
  if debug then
    player:drawDebug()
    for i,v in ipairs(tiles) do
      v:drawDebug()
    end
    for i,v in ipairs(enemies) do
      v:drawDebug()
    end
    for i,v in ipairs(chaseEnemies) do
      v:drawDebug()
    end
    for i,v in ipairs(rightLeftEnemies) do
      v:drawDebug()
    end
    for i,v in ipairs(items) do
      v:drawDebug()
    end
    for i,v in ipairs(bullets) do
      v:drawDebug()
    end
    for i,v in ipairs(missleBullets) do
      v:drawDebug()
    end
    for i,v in ipairs(bite) do
      v:drawDebug()
    end
  end
end

--- Draws a controler on mobile devices
-- so the player can see where he should
-- click to activate ingame player actions.
function drawMobileControler()
  love.graphics.setColor( 255, 255, 255, 50 )
  love.graphics.draw(mobileCntrl, 25, 500, 0, 1, 1)
  love.graphics.setColor( 255, 255, 255, 255 )
end

--- Draws all graphics that act as a head-up display.
function drawHUD()
  love.graphics.setFont(font.bold)
  love.graphics.setColor(16,12,9)
  love.graphics.print("ITEMS: " .. player.items, 170, 8)
  love.graphics.print("WEAPON: " .. "1", 170, 20)
  love.graphics.setColor(255,255,255)
end

--- Checks for key release events.
-- @param key Keyboard key that has been released
function gameState:keyreleased(key)
  if key == 'w' then player:setMovingUp(false)    end
  if key == 'd' then player:setMovingRight(false) end
  if key == 's' then player:setMovingDown(false)  end
  if key == 'a' then player:setMovingLeft(false)  end
end

--- Checks for key press events.
-- @param key Keyboard key that has been pressed
function gameState:keypressed(key)
  if key == "w" then
    player:jump()
  end

  if key == "space" then
    player:shot()
  end

  if key == "x" then
    player:dash()
  end

  if key == "left" or key == "right" then
    if key == "left" then
      local min = math.min(config.scale - 1, 4)
      config.scale = math.max(min, 1)
    elseif key == "right" then
      local min = math.min(config.scale + 1, 4)
      config.scale = math.max(min, 1)
    end
    setMode()
  end

  if key == "escape" then
    Gamestate.switch(menuState)
  end
end

--- Checks for gamepad release events.
-- @param joystick
-- @param button
function gameState:gamepadreleased(joystick, button)
  if button == 'dpup' then player:setMovingUp(false)       end
  if button == 'dpright' then player:setMovingRight(false) end
  if button == 'dpdown' then player:setMovingDown(false)   end
  if button == 'dpleft' then player:setMovingLeft(false)   end

  if button == 'leftx' then
    player:setMovingRight(false)
    player:setMovingLeft(false)
  end
end

--- Checks for gamepad press events.
-- @param joystick
-- @param button
function gameState:gamepadpressed(joystick, button)
  if button == "a" then
    if player.state == PLAYERSTATE_CLIMBING then
      player.state = PLAYERSTATE_WALKING
    end
    player:jump()
  end

  if button == "x" then player:shot() end
  if button == "b" then player:dash() end
end
