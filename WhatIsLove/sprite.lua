Sprite         = {}
Sprite.__index = Sprite

function Sprite:_init(image, frameCout, width, height)
  local self = setmetatable({}, Sprite)

  self.image        = love.graphics.newImage(image)
  self.frames       = {}
  self.frameCout    = frameCout
  self.currentFrame = 1
  self.timeElapsed  = 0
  self.frameTime    = 1

  for i=1, frameCout, 1 do
    self.frames[i] = love.graphics.newQuad(
      (i-1)*(self.image:getWidth() / frameCout),
      0,
      self.image:getWidth() / frameCout,
      self.image:getHeight(),
      self.image:getDimensions()
     )
  end

  return self
end

function Sprite:update(dt)
  self.timeElapsed = self.timeElapsed + dt

  if self.timeElapsed > 1 then
    if self.currentFrame < self.frameCout then
      self.currentFrame = self.currentFrame + 1
    else
      self.currentFrame = 1
    end
  end
end

function Sprite:draw(x, y, image)
  love.graphics.draw(
    self.image,
    self.frames[self.currentFrame],
    x,y
  )
end

function Sprite:getWidth(self)
  return self.image:getWidth()/self.frameCout
end

function Sprite:getHeight(self)
  return self.image:getHeight()
end
