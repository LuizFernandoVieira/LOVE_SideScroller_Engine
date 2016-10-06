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

--- Initializes item.
-- @param x Position in the x axis that this object will be placed
-- @param y Position in the y axis that this object will be placed
function Item:_init(x, y)
  GameObject:_init(x, y)

  self.type      = "Item"
  self.sprite    = Sprite:_init(ITEM_IMAGE, 1, 1)
  self.box       = Rect(x, y, self.sprite:getWidth(), self.sprite:getHeight())
  self.collected = false
end

--- Updates the item object.
-- Called once once each love.update.
-- @param dt Time passed since last update
function Item:update(dt)
  self.sprite:update(dt)
end

--- Draws the item object.
-- Called once once each love.draw.
function Item:draw()
  self.sprite:draw(self.box.x, self.box.y, 0)
end

--- Draws the item outline and collision area.
-- Called once once each love.draw if debug parameter passed.
function Item:drawDebug()
  local lg = love.graphics
  local x  = self.box.x
  local y  = self.box.y
  local w  = self.box.w
  local h  = self.box.h
  lg.setColor(255, 0, 0, 50)
  lg.rectangle("fill", x, y, w, h)
  lg.setColor(255, 0, 0)
  lg.rectangle("line", x, y, w, h)
  lg.setColor(255, 255, 255)
end

--- Checks if item has been collected.
-- Once the item has been collected it shoud be destroyed.
-- @return boolean
function Item:isDead()
  if self.collected then
    return true
  end
  return false
end

--- Notifies the item that a collision involving himself had ocurred.
-- The item (subject) had previously subscribed
-- to the collision system (observer).
-- @param other
function Item:notifyCollision(other)
  if other.type == "Player" then
    self.collected = true
  end
end

--- Specifies the type of that object.
-- @param type
-- @return boolean
function Item:is(type)
  return type == self.type
end
