player   = {}
tiles    = {}
map      = {}
enemies  = {}
items    = {}

function gameState:init()
  player  = Player(200, 200)

  loadEnemies()
  loadItems()

  map = Map:_init()
end

function loadEnemies()
  table.insert(enemies, Enemy(400, 400))
  table.insert(enemies, Enemy(600, 400))
end

function loadItems()
  table.insert(items, Item(400, 600))
  table.insert(items, Item(600, 600))
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

function checkCollision()
  -- for i,v in ipairs(enemies) do
  --   if isColliding(player, v) then
  --     player:notifyCollision(enemies[i])
  --     enemies[i]:notifyCollision(player)
  --   end
  -- end
end

function isColliding(a, b, angleOfA, angleOfB)
end

-- static inline bool IsColliding(const Rect& a, const Rect& b, float angleOfA, float angleOfB) {
--     Point A[] = { Point( a.x, a.y + a.h ),
--                   Point( a.x + a.w, a.y + a.h ),
--                   Point( a.x + a.w, a.y ),
--                   Point( a.x, a.y )
--                 };
--     Point B[] = { Point( b.x, b.y + b.h ),
--                   Point( b.x + b.w, b.y + b.h ),
--                   Point( b.x + b.w, b.y ),
--                   Point( b.x, b.y )
--                 };
--
--     for (auto& v : A) {
--         v = Rotate(v - a.Center(), angleOfA) + a.Center();
--     }
--     for (auto& v : B) {
--         v = Rotate(v - b.Center(), angleOfB) + b.Center();
--     }
--     Point axes[] = { Norm(A[0] - A[1]), Norm(A[1] - A[2]), Norm(B[0] - B[1]), Norm(B[1] - B[2]) };
--     for (auto& axis : axes) {
--         float P[4];
--         for (int i = 0; i < 4; ++i) P[i] = Dot(A[i], axis);
--         float minA = *std::min_element(P, P + 4);
--         float maxA = *std::max_element(P, P + 4);
--         for (int i = 0; i < 4; ++i) P[i] = Dot(B[i], axis);
--         float minB = *std::min_element(P, P + 4);
--         float maxB = *std::max_element(P, P + 4);
--         if (maxA < minB || minA > maxB)
--             return false;
--     }
--     return true;
-- }

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
