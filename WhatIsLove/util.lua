--- Checks collision for all objects in the game.
-- Notify those objects that collided.
function checkCollision()
  -- Tiles
  checkCollisionBetweenPlayerAnd(tiles)
  checkCollisionBetweenBossAnd(tiles)
  checkCollisionBetween(tiles, enemies)
  checkCollisionBetween(tiles, shootEnemies)
  checkCollisionBetween(tiles, chaseEnemies)
  checkCollisionBetween(tiles, rightLeftEnemies)
  checkCollisionBetween(tiles, defShotEnemies)
  checkCollisionBetween(tiles, shieldEnemies)
  checkCollisionBetween(tiles, bombs)
  checkCollisionBetween(tiles, defShotEnemiesBullets)
  -- Enemies
  checkCollisionBetweenPlayerAnd(enemies)
  checkCollisionBetween(enemies, bite)
  checkCollisionBetween(enemies, bullets)
  checkCollisionBetween(enemies, missleBullets)
  checkCollisionBetween(enemies, shotgunBullets)
  checkCollisionBetween(enemies, machinegunBullets)
  -- ChaseEnemies
  checkCollisionBetweenPlayerAnd(chaseEnemies)
  checkCollisionBetween(chaseEnemies, bite)
  checkCollisionBetween(chaseEnemies, bullets)
  checkCollisionBetween(chaseEnemies, missleBullets)
  checkCollisionBetween(chaseEnemies, shotgunBullets)
  checkCollisionBetween(chaseEnemies, machinegunBullets)
  -- DefShotEnemies
  checkCollisionBetweenPlayerAnd(defShotEnemies)
  checkCollisionBetween(defShotEnemies, bullets)
  checkCollisionBetween(defShotEnemies, missleBullets)
  checkCollisionBetween(defShotEnemies, shotgunBullets)
  checkCollisionBetween(defShotEnemies, machinegunBullets)
  -- Right Left Enemy
  checkCollisionBetweenPlayerAnd(rightLeftEnemies)
  checkCollisionBetween(rightLeftEnemies, bullets)
  checkCollisionBetween(rightLeftEnemies, missleBullets)
  checkCollisionBetween(rightLeftEnemies, shotgunBullets)
  checkCollisionBetween(rightLeftEnemies, machinegunBullets)
  -- Shoot Enemies
  checkCollisionBetweenPlayerAnd(shootEnemies)
  checkCollisionBetween(shootEnemies, bullets)
  checkCollisionBetween(shootEnemies, missleBullets)
  checkCollisionBetween(shootEnemies, shotgunBullets)
  checkCollisionBetween(shootEnemies, machinegunBullets)
  -- Flybomb Enemies
  checkCollisionBetweenPlayerAnd(flybombEnemies)
  checkCollisionBetween(flybombEnemies, bullets)
  checkCollisionBetween(flybombEnemies, missleBullets)
  checkCollisionBetween(flybombEnemies, shotgunBullets)
  checkCollisionBetween(flybombEnemies, machinegunBullets)
  -- Shield Enemies
  checkCollisionBetweenPlayerAnd(shieldEnemies)
  checkCollisionBetween(shieldEnemies, bullets)
  checkCollisionBetween(shieldEnemies, missleBullets)
  checkCollisionBetween(shieldEnemies, shotgunBullets)
  checkCollisionBetween(shieldEnemies, machinegunBullets)
  -- SpikeEnemy
  checkCollisionBetweenPlayerAnd(spikeEnemies)
  checkCollisionBetween(spikeEnemies, bullets)
  checkCollisionBetween(spikeEnemies, missleBullets)
  checkCollisionBetween(spikeEnemies, shotgunBullets)
  checkCollisionBetween(spikeEnemies, machinegunBullets)
  -- Player
  checkCollisionBetweenPlayerAnd(defShotEnemiesBullets)
  checkCollisionBetweenPlayerAnd(ladders)
  checkCollisionBetweenPlayerAnd(items)
  checkCollisionBetweenPlayerAnd(weapons)
  checkCollisionBetweenPlayerAnd(shotEnemyBullets)
  checkCollisionBetweenPlayerAnd(blobEnemyBullets)
end

-- @param a
function checkCollisionBetweenPlayerAnd(a)
  for i,v in ipairs(a) do
    if isColliding(player.box, v.box, player.rotation, v.rotation) then
      player:notifyCollision(a[i])
      a[i]:notifyCollision(player)
    end
  end
end

-- @param a
function checkCollisionBetweenBossAnd(a)
  for i,v in ipairs(a) do
    if isColliding(boss.box, v.box, boss.rotation, v.rotation) then
      boss:notifyCollision(a[i])
      a[i]:notifyCollision(boss)
    end
  end
end

-- @param a
-- @param b
function checkCollisionBetween(a, b)
  for i,v in ipairs(a) do
    for j,u in ipairs(b) do
      if isColliding(u.box, v.box, u.rotation, v.rotation) then
        v:notifyCollision(b[j])
        u:notifyCollision(a[i])
      end
    end
  end
end

--- Handle collision.
-- @param x
-- @param y
-- @param vel
-- @return correctPosition
function handleCollision(x, y, vel, dt)
  for _,t in ipairs(tiles) do

    local velocity
    if player.facingRight then
      velocity = vel
    else
      velocity = -vel
    end

    local nextBox = {}

    local interval
    if velocity < 0 then
      interval = - 0.01
    else
      interval = 0.01
    end

    if velocity < 0 then
      nextBox = Rect(
        player.box.x - player.velocity * dt,
        player.box.y,
        player.sprite:getWidth(),
        player.sprite:getHeight())
    else
      nextBox = Rect(
        player.box.x + player.velocity * dt,
        player.box.y,
        player.sprite:getWidth(),
        player.sprite:getHeight())
    end

    if isColliding(nextBox, t.box) then
      for vx=0, velocity, interval do

        local auxX

        if vx > 0 then auxX = player.box.x + vx * dt
        else auxX = player.box.x - 0.1 - vx * dt end

        local imaginaryRect = Rect(
          auxX,
          player.box.y,
          player.sprite:getWidth(),
          player.sprite:getHeight()
        )

        if isColliding(imaginaryRect, t.box) then
          return vx
        end
      end
    end
  end

  return vel
end

-- @param a
-- @param b
-- @param r
-- @ return boolean
function isCollidingPointCircle(a, b, r)
  return (a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y) < r * r
end

--- Checks if two objects are colliding.
-- @param a
-- @param b
-- @return boolean
function isColliding(a, b)
  if a.x < b.x + b.w and a.x + a.w > b.x
  and a.y < b.y + b.h and a.y + a.h > b.y then
    return true
  end
  return false
end

--- Checks if two objects are colliding considering their
-- position and their rotation.
-- @param a
-- @param b
-- @param angleOfA
-- @param angleOfB
-- @return boolean
function complexIsColliding(a, b, angleOfA, angleOfB)
  local A = {
    Vector(a.x + 000, a.y + a.h),
    Vector(a.x + a.w, a.y + a.h),
    Vector(a.x + a.w, a.y + 000),
    Vector(a.x + 000, a.y + 000)
  }
  local B = {
    Vector(b.x + 000, b.y + b.h),
    Vector(b.x + b.w, b.y + b.h),
    Vector(b.x + b.w, b.y + 000),
    Vector(b.x + 000, b.y + 000)
  }

  for _,v in ipairs(A) do
    local vecSub = subVec(v, a:center())
    local vecSum = sumVec(rotate(vecSub, angleOfA), a:center())
    v = vecSum
  end

  for _,v in ipairs(B) do
    local vecSub = subVec(v, b:center())
    local vecSum = sumVec(rotate(vecSub, angleOfB), b:center())
    v = vecSum
  end

  local axes = {
    norm(subVec(A[1], A[2])),
    norm(subVec(A[2], A[3])),
    norm(subVec(B[1], B[2])),
    norm(subVec(B[2], B[3]))
  }

  for _,axis in ipairs(axes) do
    local P = {}

    for i=1, 4, 1 do
      P[i] = dot(A[i], axis)
    end

    local minA = math.min(P[1], P[2], P[3], P[4])
    local maxA = math.max(P[1], P[2], P[3], P[4])

    for i=1, 4, 1 do
      P[i] = dot(B[i], axis)
    end

    local minB = math.min(P[1], P[2], P[3], P[4])
    local maxB = math.max(P[1], P[2], P[3], P[4])

    if maxA < minB or minA > maxB then
      return false
    end
  end

  return true
end

--- Sum two vectors.
-- @param v1
-- @param v2
-- @return table
function sumVec(v1, v2)
  local vec = Vector(0, 0)
  vec.x = v1.x + v2.x
  vec.y = v1.y + v2.y
  return vec
end

--- Subtract two vectors.
-- @param v1
-- @param v2
-- @return table
function subVec(v1, v2)
  local vec = Vector(0, 0)
  vec.x = v1.x - v2.x
  vec.y = v1.y - v2.y
  return vec
end

--- Multiply two vector.
-- @param v1
-- @param v2
-- @return table
function multVec(v1, v2)
  local vec = Vector(0, 0)
  vec.x = v1.x * v2.x
  vec.y = v1.y * v2.y
  return vec
end

--- Multiply vector with scalar.
-- @param v
-- @param s
-- @return table
function multVecWithScalar(v, s)
  local vec = Vector(0, 0)
  vec.x = v.x * s
  vec.y = v.y * s
  return vec
end

--- Calculates the magniture of a vector.
-- @param vec
-- @return number
function mag(vec)
  return math.sqrt(vec.x * vec.x + vec.y + vec.y)
end

--- Normalizes a vector.
-- @param vec
-- @return table
function norm(vec)
  local bla = mag(vec)
  local inverseMag = (1 / mag(vec))
  return multVecWithScalar(vec, inverseMag)
end

---
-- @param a
-- @param b
-- @return number
function dot(a, b)
  return a.x * b.x + a.y * b.y
end

--- Rotates a vector.
-- @param vec
-- @param ang
-- @return table
function rotate(vec, ang)
  local cs = math.cos(ang)
  local sn = math.sin(ang)
  return Vector(
    vec.x * cs - vec.y * sn,
    vec.x * sn + vec.y * cs
  )
end

---
--
-- @param val
-- @param min
-- @param max
-- @return number
function wrap(val, min, max)
	if val < min then val = max end
	if val > max then val = min end
	return val
end

---
--
-- @param val
-- @param min
-- @param max
-- @return number
function cap(val, min, max)
	return math.max(math.min(val, max), min)
end

---
--
function setZoom()
  local cf = config.fullscreen
  local cs = config.scale
  local lg = love.graphics
  local w = WIDTH
  local h = HEIGHT
	if cf == 1 then
		local sw = lg.getWidth() / w / cs
		local sh = lg.getHeight() / h / cs
		lg.scale(sw,sh)
	elseif cf == 2 then
		local sw = lg.getWidth() / w / cs
		local sh = lg.getHeight() / h / cs
		local tx = (lg.getWidth() - w * cs * sh) / 2
		lg.translate(tx, 0)
		lg.scale(sh, sh)
		lg.setScissor(tx, 0, w*cs*sh, lg.getHeight())
	elseif cf == 3 then
		lg.translate(fs_translatex, fs_translatey)
		lg.setScissor(fs_translatex, fs_translatey, w*cs, h*cs)
	end
end
