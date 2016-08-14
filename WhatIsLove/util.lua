function wrap(val, min, max)
	if val < min then val = max end
	if val > max then val = min end
	return val
end

function checkCollision()
  for i,v in ipairs(tiles) do
    if isColliding(player.box, v.box, player.rotation, v.rotation) then
      print("colidiu!!!")
      player:notifyCollision(tiles[i])
      tiles[i]:notifyCollision(player)
    end
  end

  for i,v in ipairs(items) do
    if isColliding(player.box, v.box, player.rotation, v.rotation) then
      print("colidiu!!!")
      player:notifyCollision(items[i])
      items[i]:notifyCollision(player)
    end
  end

  for i,v in ipairs(enemies) do
    if isColliding(player.box, v.box, player.rotation, v.rotation) then
      print("colidiu!!!")
      player:notifyCollision(enemies[i])
      enemies[i]:notifyCollision(player)
    end
  end
end

function isColliding(a, b, angleOfA, angleOfB)
  local A = {
    Vector(a.x + 000, a.y + a.h),
    Vector(a.x + a.w, a.y + a.h),
    Vector(a.x + a.w, a.y + 000),
    Vector(a.x + 000, a.y + 000),
  }
  local B = {
    Vector(b.x + 000, b.y + b.h),
    Vector(b.x + b.w, b.y + b.h),
    Vector(b.x + b.w, b.y + 000),
    Vector(b.x + 000, b.y + 000),
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

    if maxA < minB or minA > minB then
      return false
    end
  end

  return true
end

function sumVec(v1, v2)
  local vec = Vector(0, 0)
  vec.x = v1.x + v2.x
  vec.y = v1.y + v2.y
  return vec
end

function subVec(v1, v2)
  local vec = Vector(0, 0)
  vec.x = v1.x - v2.x
  vec.y = v1.y - v2.y
  return vec
end

function multVec(v1, v2)
  local vec = Vector(0, 0)
  vec.x = v1.x * v2.x
  vec.y = v1.y * v2.y
  return vec
end

function multVecWithScalar(v, s)
  local vec = Vector(0, 0)
  vec.x = v.x * s
  vec.y = v.y * s
  return vec
end

function mag(vec)
  return math.sqrt(vec.x * vec.x + vec.y + vec.y)
end

function norm(vec)
  local bla = mag(vec)
  local inverseMag = (1 / mag(vec))
  return multVecWithScalar(vec, inverseMag)
end

function dot(a, b)
  return a.x * b.x + a.y * b.y
end

function rotate(vec, ang)
  local cs = math.cos(ang)
  local sn = math.sin(ang)
  return Vector(
    vec.x * cs - vec.y * sn,
    vec.x * sn + vec.y * cs
  )
end