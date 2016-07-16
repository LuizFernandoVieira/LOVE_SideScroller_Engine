Item         = {}
Item.__index = Item

setmetatable(Item, {
  __index = GameObject,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Item:_init(x, y, imgPath, imgWidth, imgHeight)
  GameObject._init(self, x, y)

  self.name   = "Item"
  self.sprite = Sprite._init(self, imgPath, 1, imgWidth, imgHeight)
end

function Item:update(dt)
  self.sprite:update(dt)
end

function Item:draw()
  self.sprite:draw(self.x, self.y, self.image)
end
