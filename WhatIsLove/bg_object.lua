BgObject          = {}
BgObject.__index  = BgObject

setmetatable(BgObject, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

--- Initializes game object.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
function BgObject:_init(x, y, bgImage)
  GameObject:_init(x, y)

  self.box    = Rect(x, y, 0, 0)
  self.sprite = Sprite(bgImage, 1, 1)
end

--- Updates the game object
-- Called once once each love.update
-- @param dt Time passed since last update
function BgObject:update(dt)
  self.sprite:update(dt)
end

--- Draws the game object.
-- Called once once each love.draw.
function BgObject:draw()
  self.sprite:draw(self.box.x, self.box.y)
end

--- Specifies the type of that object.
-- @param type
-- @return boolean
function BgObject:is(type)
  return type == "BgObject"
end
