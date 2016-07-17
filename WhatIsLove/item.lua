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

local ITEM_IMAGE = "img/misc/spr_star_0.png"

function Item:_init(x, y)
  GameObject:_init(x, y)

  self.name   = "Item"
  self.sprite = Sprite:_init(ITEM_IMAGE, 1, 1)
  self.box    = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
end

function Item:update(dt)
  self.sprite:update(dt)
end

function Item:draw()
  self.sprite:draw(self.box.x, self.box.y, 0)
end
