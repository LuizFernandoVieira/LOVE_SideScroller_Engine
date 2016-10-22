player           = {}
tiles            = {}
map              = {}
enemies          = {}
chaseEnemies     = {}
rightLeftEnemies = {}
flybombEnemies   = {}
defShotEnemies   = {}
items            = {}
particles        = {}
bullets          = {}
bombs            = {}
missleBullets    = {}
bite             = {}
ladders          = {}
weapons          = {}

bgObjects        = {}

defShotEnemiesBullets = {}
machinegunBullets = {}

psystem     = {}
mobileCntrl = love.graphics.newImage("img/mobile_cntrl.png")

sound     = love.audio.newSource("audio/teste.mp3")
jumpSound = love.audio.newSource("audio/jump.wav")
shotSound = love.audio.newSource("audio/shot.wav")

overlayImg = love.graphics.newImage("img/Overlay.png")

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
  -- table.insert(enemies, Enemy(200, 0))
  table.insert(chaseEnemies, ChaseEnemy(250, 0))
  table.insert(rightLeftEnemies, RightLeftEnemy(350, 0))
  table.insert(flybombEnemies, FlybombEnemy(450, 70))
  table.insert(flybombEnemies, FlybombEnemy(550, 70))
  table.insert(defShotEnemies, DefShotEnemy(200, 0))
end

--- Initializes items.
function loadItems()
  table.insert(items, Item(30, 150))
  table.insert(items, Item(35, 160))
  table.insert(items, Item(20, 150))
  table.insert(items, Item(25, 160))
  table.insert(items, Item(10, 150))
  table.insert(items, Item(15, 160))
  table.insert(items, Antidote(100, 150))
  table.insert(ladders, Ladder(230, 120))
  table.insert(weapons, Gun(100, 100))
  table.insert(weapons, Shotgun(100, 100))
  table.insert(weapons, Misslegun(150, 100))
  table.insert(weapons, Machinegun(0, 150))
end

-- Initializes background objects.
function loadBackgroundObjects()
  table.insert(bgObjects, BgObject(200, 60, "img/BackgroundTree.png"))
  table.insert(bgObjects, BgObject(300, 60, "img/BackgroundTree.png"))
  table.insert(bgObjects, BgObject(400, 60, "img/BackgroundTree.png"))
  table.insert(bgObjects, BgObject(500, 60, "img/BackgroundTree.png"))
  table.insert(bgObjects, BgObject(600, 60, "img/BackgroundTree.png"))
end

--- Initializes audio.
function loadAudio()
  -- splashSound:stop()
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
  camera:move(dx/2, 0)

  -- psystem:update(dt)

  updateGameObjects(dt, enemies)
  updateGameObjects(dt, chaseEnemies)
  updateGameObjects(dt, rightLeftEnemies)
  updateGameObjects(dt, flybombEnemies)
  updateGameObjects(dt, defShotEnemies)
  updateGameObjects(dt, items)
  updateGameObjects(dt, bullets)
  updateGameObjects(dt, missleBullets)
  updateGameObjects(dt, defShotEnemiesBullets)
  updateGameObjects(dt, machinegunBullets)
  updateGameObjects(dt, bombs)
  updateGameObjects(dt, ladders)
  updateGameObjects(dt, weapons)
  updateGameObjects(dt, bite)
  updateGameObjects(dt, bgObjects)

  checkCollision()
  deleteDeadEntities()
end

--- Updates gameObjects passed as a parameter.
-- Called each love.update for each entity type.
-- @param dt Time passed since last update
-- @param gameObjects List of game objects
function updateGameObjects(dt, gameObjects)
  for _,v in ipairs(gameObjects) do
    if isInsideCamera(v) then
      v:update(dt)
    end
  end
end

function isInsideCamera(gameObject)
  local lgw = love.graphics.getWidth()
  local cx, cy = camera:position()
  if gameObject.box.x > cx - lgw/2
  and gameObject.box.x < cx + lgw/2 then
    return true
  end
  return false
end

--- Deletes entities marked as dead.
function deleteDeadEntities()
  deleteDead(enemies)
  deleteDead(chaseEnemies)
  deleteDead(rightLeftEnemies)
  deleteDead(flybombEnemies)
  deleteDead(defShotEnemies)
  deleteDead(items)
  deleteDead(bite)
  deleteDead(bullets)
  deleteDead(defShotEnemiesBullets)
  deleteDead(machinegunBullets)
  deleteDead(missleBullets)
  deleteDead(bombs)
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

  if player.state == PLAYERSTATE_DEAD then
    return
  end

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

  love.graphics.setBackgroundColor(230, 214, 156)
  love.graphics.draw(tilesetBatch)

  drawGameObjects(bgObjects)
  drawGameObjects(enemies)
  drawGameObjects(chaseEnemies)
  drawGameObjects(rightLeftEnemies)
  drawGameObjects(flybombEnemies)
  drawGameObjects(defShotEnemies)
  drawGameObjects(items)
  -- drawGameObjects(ladders)
  drawGameObjects(bullets)
  drawGameObjects(defShotEnemiesBullets)
  drawGameObjects(machinegunBullets)
  drawGameObjects(missleBullets)
  drawGameObjects(bombs)
  drawGameObjects(bite)
  drawGameObjects(weapons)

  player:draw()

  drawDebug()

  camera:detach()

  -- love.graphics.draw(
  -- psystem, love.graphics.getWidth() *
  -- 0.5, love.graphics.getHeight() * 0.5)

  drawMobileTouches()

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
    drawDebugGameObjects(tiles)
    drawDebugGameObjects(enemies)
    drawDebugGameObjects(chaseEnemies)
    drawDebugGameObjects(rightLeftEnemies)
    drawDebugGameObjects(flybombEnemies)
    drawDebugGameObjects(defShotEnemies)
    drawDebugGameObjects(items)
    drawDebugGameObjects(bullets)
    drawDebugGameObjects(defShotEnemiesBullets)
    drawDebugGameObjects(machinegunBullets)
    drawDebugGameObjects(missleBullets)
    drawDebugGameObjects(bombs)
    drawDebugGameObjects(bite)
  end
end

function drawDebugGameObjects(gameObjects)
  for _,v in ipairs(gameObjects) do
    v:drawDebug()
  end
end

--- Draws all graphics that act as a head-up display.
function drawHUD()
  love.graphics.draw(love.graphics.newImage("img/Overlay.png"), 0, 0)
  love.graphics.setFont(font.bold)
  love.graphics.setColor(179, 164, 106)
  love.graphics.print("STAGE: " .. "1", 10, 2)
  love.graphics.print("BLABLA: " .. "25", 10, 9)
  love.graphics.print("ITEMS: " .. player.items, 90, 2)
  love.graphics.print("WEAPON: " .. player.weapon, 90, 9)
  love.graphics.setColor(255,255,255)
end

--- Checks for key press events.
-- @param key Keyboard key that has been pressed
function gameState:keypressed(key)
  if player.state == PLAYERSTATE_DEAD then
    return
  end

  if key == "w"     then player:jump() end
  if key == "space" then player:shot() end
  if key == "x"     then player:dash() end

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

  if key == "escape" then Gamestate.switch(menuState) end
end

--- Checks for key release events.
-- @param key Keyboard key that has been released
function gameState:keyreleased(key)
  if key == 'w' then player:setMovingUp(false)    end
  if key == 'd' then player:setMovingRight(false) end
  if key == 's' then player:setMovingDown(false)  end
  if key == 'a' then player:setMovingLeft(false)  end
end

--- Checks for gamepad press events.
-- @param joystick
-- @param button
function gameState:gamepadpressed(joystick, button)
  if player.state == PLAYERSTATE_DEAD then
    return
  end

  if button == "a" then
    if player.state == PLAYERSTATE_CLIMBING then
      player.state = PLAYERSTATE_WALKING
    end
    player:jump()
  end

  if button == "x" then player:shot() end
  if button == "b" then player:dash() end
end

--- Checks for gamepad release events.
-- @param joystick
-- @param button
function gameState:gamepadreleased(joystick, button)
  if button == 'dpup'    then player:setMovingUp(false)    end
  if button == 'dpright' then player:setMovingRight(false) end
  if button == 'dpdown'  then player:setMovingDown(false)  end
  if button == 'dpleft'  then player:setMovingLeft(false)  end

  if button == 'leftx' then
    player:setMovingRight(false)
    player:setMovingLeft(false)
  end
end
