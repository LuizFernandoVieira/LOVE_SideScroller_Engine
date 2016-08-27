player    = {}
tiles     = {}
map       = {}
enemies   = {}
items     = {}
particles = {}
bullets   = {}

function gameState:init()
  player = Player(0, 0)

  camera = Camera(player.box.x, player.box.y)

  loadEnemies()
  loadItems()

  map = Map:_init()
end

function loadEnemies()
  table.insert(enemies, Enemy(80, 160))
  table.insert(enemies, Enemy(150, 150))
end

function loadItems()
  table.insert(items, Item(40, 150))
  table.insert(items, Item(200, 150))
end

function gameState:update(dt)
  handleInputs()
  player:update(dt)

  local dx = player.box.x - camera.x
  local dy = player.box.y - camera.y
  camera:move(dx/2, dy/2)

  updateEnemies(dt)
  updateItems(dt)
  updateBullets(dt)

  checkCollision()
end

function updateEnemies(dt)
  for i,v in ipairs(enemies) do
    v:update(dt)
  end
end

function updateItems(dt)
  for i,v in ipairs(items) do
    v:update(dt)
  end
end

function updateBullets(dt)
  for _,v in ipairs(bullets) do
    v:update(dt)
  end
end

function handleInputs()
  if love.keyboard.isDown('w') then
    player:setMovingUp(true)
  end
  if love.keyboard.isDown('d') then
    player:setMovingRight(true)
  end
  if love.keyboard.isDown('s') then
    player:setMovingDown(true)
  end
  if love.keyboard.isDown('a') then
    player:setMovingLeft(true)
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
end

function gameState:draw()
  love.graphics.push()

  setZoom()
  love.graphics.scale(config.scale)

  -- camera:attach()

  love.graphics.draw(tilesetBatch)
  player:draw()

  drawEnemies()
  drawItems()
  drawBullets()

  drawDebug()

  -- camera:detach()

  drawHUD()

  love.graphics.pop()
  love.graphics.setScissor()
end

function drawEnemies()
  for i,v in ipairs(enemies) do
    v:draw()
  end
end

function drawItems()
  for i,v in ipairs(items) do
    v:draw()
  end
end

function drawBullets()
  for _,v in ipairs(bullets) do
    v:draw()
  end
end

function drawDebug()
  player:drawDebug()
  for i,v in ipairs(tiles) do
    v:drawDebug()
  end
  for i,v in ipairs(enemies) do
    v:drawDebug()
  end
  for i,v in ipairs(items) do
    v:drawDebug()
  end
  for i,v in ipairs(bullets) do
    v:drawDebug()
  end
end

function drawHUD()
  love.graphics.setFont(font.bold)
  love.graphics.setColor(16,12,9)
  -- trocar numero depois de items pela var items
  love.graphics.print("ITEMS: " .. player.items, 170, 8)
  love.graphics.print("HEALTH: " .. player.health, 170, 20)
  love.graphics.setColor(255,255,255)
end

function gameState:keyreleased(key)
  if key == 'w' then
    player:setMovingUp(false)
  end
  if key == 'd' then
    player:setMovingRight(false)
  end
  if key == 's' then
    player:setMovingDown(false)
  end
  if key == 'a' then
    player:setMovingLeft(false)
  end
end

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
      config.scale = math.max(math.min(config.scale - 1, 4), 1)
    elseif key == "right" then
      config.scale = math.max(math.min(config.scale + 1, 4), 1)
    end
    setMode()
  end

  if key == "escape" then
    Gamestate.switch(menuState)
  end
end

function gameState:gamepadreleased(joystick, button)
  if button == 'dpup' then
    player:setMovingUp(false)
  end
  if button == 'dpright' then
    player:setMovingRight(false)
  end
  if button == 'dpdown' then
    player:setMovingDown(false)
  end
  if button == 'dpleft' then
    player:setMovingLeft(false)
  end

  if button == 'leftx' then
    player:setMovingRight(false)
    player:setMovingLeft(false)
  end
end

function gameState:gamepadpressed(joystick, button)
  if button == "a" then
    player:jump()
  end

  if button == "x" then
    player:shot()
  end

  if button == "y" then
    player:dash()
  end
end
