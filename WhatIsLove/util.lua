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
	if config.fullscreen == 1 then
		local sw = love.graphics.getWidth()/WIDTH/config.scale
		local sh = love.graphics.getHeight()/HEIGHT/config.scale
		love.graphics.scale(sw,sh)
	elseif config.fullscreen == 2 then
		local sw = love.graphics.getWidth()/WIDTH/config.scale
		local sh = love.graphics.getHeight()/HEIGHT/config.scale
		local tx = (love.graphics.getWidth() - WIDTH*config.scale*sh)/2
		love.graphics.translate(tx, 0)
		love.graphics.scale(sh, sh)
		love.graphics.setScissor(tx, 0, WIDTH*config.scale*sh, love.graphics.getHeight())
	elseif config.fullscreen == 3 then
		love.graphics.translate(fs_translatex,fs_translatey)
		love.graphics.setScissor(fs_translatex, fs_translatey, WIDTH*config.scale, HEIGHT*config.scale)
	end
end

---
--
function checkCollision()
  for i,v in ipairs(tiles) do
    if isColliding(player.box, v.box, player.rotation, v.rotation) then
      player:notifyCollision(tiles[i])
      tiles[i]:notifyCollision(player)
    end
  end

  for i,v in ipairs(ladders) do
    if isColliding(player.box, v.box, player.rotation, v.rotation) then
      player:notifyCollision(ladders[i])
      ladders[i]:notifyCollision(player)
    end
  end

  for i,v in ipairs(tiles) do
    for j,u in ipairs(enemies) do
      if isColliding(u.box, v.box, u.rotation, v.rotation) then
        v:notifyCollision(enemies[j])
        u:notifyCollision(tiles[i])
      end
    end
  end

  for i,v in ipairs(items) do
    if isColliding(v.box, player.box, v.rotation, player.rotation) then
      items[i]:notifyCollision(player)
      player:notifyCollision(items[i])
    end
  end

  for i,v in ipairs(weapons) do
    if isColliding(v.box, player.box, v.rotation, player.rotation) then
      weapons[i]:notifyCollision(player)
      player:notifyCollision(weapons[i])
    end
  end

  for i,v in ipairs(enemies) do
    if isColliding(player.box, v.box, player.rotation, v.rotation) then
      player:notifyCollision(enemies[i])
      enemies[i]:notifyCollision(player)
    end

    for j,u in ipairs(bullets) do
      if isColliding(u.box, v.box, u.rotation, v.rotation) then
        v:notifyCollision(bullets[j])
        u:notifyCollision(enemies[i])
      end
    end
  end

  for i,v in ipairs(enemies) do
    for j,u in ipairs(bite) do
      if isColliding(v.box, u.box, v.rotation, u.rotation) then
        enemies[i]:notifyCollision(bite[j])
      end
    end
  end
end

--- Checks if two objects are colliding.
-- @param a
-- @param b
-- @param angleOfA
-- @param angleOfB
-- @return boolean
function isColliding(a, b, angleOfA, angleOfB)
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

---
--
-- @param v1
-- @param v2
-- @return table
function sumVec(v1, v2)
  local vec = Vector(0, 0)
  vec.x = v1.x + v2.x
  vec.y = v1.y + v2.y
  return vec
end

---
--
-- @param v1
-- @param v2
-- @return table
function subVec(v1, v2)
  local vec = Vector(0, 0)
  vec.x = v1.x - v2.x
  vec.y = v1.y - v2.y
  return vec
end

---
--
-- @param v1
-- @param v2
-- @return table
function multVec(v1, v2)
  local vec = Vector(0, 0)
  vec.x = v1.x * v2.x
  vec.y = v1.y * v2.y
  return vec
end

---
--
-- @param v
-- @param s
-- @return table
function multVecWithScalar(v, s)
  local vec = Vector(0, 0)
  vec.x = v.x * s
  vec.y = v.y * s
  return vec
end

---
--
-- @param vec
-- @return number
function mag(vec)
  return math.sqrt(vec.x * vec.x + vec.y + vec.y)
end

---
--
-- @param vec
-- @return table
function norm(vec)
  local bla = mag(vec)
  local inverseMag = (1 / mag(vec))
  return multVecWithScalar(vec, inverseMag)
end

---
--
-- @param a
-- @param b
-- @return number
function dot(a, b)
  return a.x * b.x + a.y * b.y
end

---
--
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
