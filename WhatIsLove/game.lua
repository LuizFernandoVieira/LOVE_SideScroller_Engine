player   = {}
tiles    = {}
map      = {}
enemies  = {}
items    = {}

function gameState:init()
  player  = Player(200, 200, "img/ninja/run1.png", 16, 16)

  loadEnemies()
  loadItems()

  map = Map:_init()  
end

function loadEnemies()
  table.insert(enemies, Enemy(400, 400, "img/misc/spr_star_0.png", 16, 16))
  table.insert(enemies, Enemy(600, 400, "img/misc/spr_star_0.png", 16, 16))
end

function loadItems()
  table.insert(items, Item(400, 600, "img/sensei/spr_boss_0.png", 16, 16))
  table.insert(items, Item(600, 600, "img/sensei/spr_boss_0.png", 16, 16))
end

function gameState:update(dt)
  handleInputs()
  player:update(dt)

  updateEnemies(dt)
  updateItems(dt)
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
end

function gameState:draw()
  love.graphics.draw(tilesetBatch)
  player:draw()

  drawEnemies()
  drawItems()
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
