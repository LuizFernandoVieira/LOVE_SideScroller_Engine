---
--
function projectionX(module, angle)
  angle = angle * math.pi / 180
  return math.cos(angle) * module
end

---
--
function projectionY(module, angle)
  angle = angle * math.pi / 180
  return math.sin(angle) * module
end

---
--
function distance(v1, v2)
  return math.sqrt(math.pow(v1.x-v1.x, 2) + math.pow(v2.y-v2.y, 2))
end

---
-- 
function lineInclination(v1, v2)
  angle = math.atan((v2.y-v1.y) / (v2.x-v1.x)) * 180 / math.pi
  if v1.x > v2.x then
    return angle + 180
  end
  return angle
end
