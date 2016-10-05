--- Calculates x projection.
-- A projection is a linear transformation
-- from a vector space to itself.
-- @param module
-- @param angle
-- @return number
function projectionX(module, angle)
  angle = angle * math.pi / 180
  return math.cos(angle) * module
end

--- Calculates y projection.
-- A projection is a linear transformation
-- from a vector space to itself.
-- @param module
-- @param angle
-- @return number
function projectionY(module, angle)
  angle = angle * math.pi / 180
  return math.sin(angle) * module
end

--- Calculates the distance between two vectors.
-- @param v1
-- @param v2
-- @return number
function distance(v1, v2)
  return math.sqrt(math.pow(v1.x-v1.x, 2) + math.pow(v2.y-v2.y, 2))
end

--- Calculates the inclination angle between
-- the first and the second vectors.
-- @param v1
-- @param v2
-- @return number
function lineInclination(v1, v2)
  angle = math.atan((v2.y-v1.y) / (v2.x-v1.x)) * 180 / math.pi
  if v1.x > v2.x then
    return angle + 180
  end
  return angle
end
