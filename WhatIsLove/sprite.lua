Sprite         = {}
Sprite.__index = Sprite

setmetatable(Sprite, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

--- Initializes sprite.
-- @param image
-- @param frameCout
-- @param frameTime
function Sprite:_init(image, frameCout, frameTime)
  self.image        = love.graphics.newImage(image)
  self.scaleX       = 1
  self.scaleY       = 1
  self.frames       = {}
  self.frameCout    = frameCout or 1
  self.currentFrame = 1
  self.timeElapsed  = 0
  self.frameTime    = frameTime or 1

  for i=1, frameCout, 1 do
    self.frames[i] = love.graphics.newQuad(
      (i-1)*(self.image:getWidth() / frameCout),
      0,
      self.image:getWidth() / frameCout,
      self.image:getHeight(),
      self.image:getDimensions()
     )
  end
end

---
--
-- @param dt Time passed since last update
function Sprite:update(dt)
  self.timeElapsed = self.timeElapsed + dt

  if self.timeElapsed > self.frameTime then
    if self.currentFrame < self.frameCout then
      self.currentFrame = self.currentFrame + 1
    else
      self.currentFrame = 1
    end
    self.timeElapsed = 0
  end
end

---
--
-- @param x
-- @param y
-- @param angle
-- @param facing
function Sprite:draw(x, y, angle, facing)
  angle = angle or 0
  facingRight = facingRight or true

  if facing == true then
    love.graphics.draw(
      self.image,
      self.frames[self.currentFrame],
      x, y, angle,
      self.scaleX, self.scaleY
    )
  else
    love.graphics.draw(
      self.image,
      self.frames[self.currentFrame],
      x + self.image:getWidth()/self.frameCout, y, angle,
      -self.scaleX, self.scaleY
    )
  end
end

---
--
-- @return number
function Sprite:getWidth()
  return self.image:getWidth()/self.frameCout
end

---
--
-- @return number
function Sprite:getHeight()
  return self.image:getHeight()
end
