player   = {}
tiles    = {}
map      = {}
enemies  = {}
items    = {}

function gameState:init()
  player = Player(16, 16)

  loadEnemies()
  loadItems()

  map = Map:_init()
end

function loadEnemies()
  table.insert(enemies, Enemy(80, 160))
  table.insert(enemies, Enemy(150, 150))
end

function loadItems()
  table.insert(items, Item(130, 150))
  table.insert(items, Item(200, 150))
end

function gameState:update(dt)
  handleInputs()
  player:update(dt)

  updateEnemies(dt)
  updateItems(dt)

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

  love.graphics.draw(tilesetBatch)
  player:draw()

  drawEnemies()
  drawItems()

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

function drawHUD()
  love.graphics.setFont(font.bold)
  love.graphics.setColor(16,12,9)
  -- trocar numero depois de items pela var items
  love.graphics.print("ITEMS: " .. 500,170,8)
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
  if key == "space" then
    player:jump()
  end

  if key == "left" or key == "right" then
    if key == "left" then
      config.scale = math.max(math.min(config.scale - 1, 4), 1)
    elseif key == "right" then
      config.scale = math.max(math.min(config.scale + 1, 4), 1)
    end
    setMode()
    print(config.scale)
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
end
