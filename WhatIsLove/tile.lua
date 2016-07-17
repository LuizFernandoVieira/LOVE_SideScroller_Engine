Tile         = {}
Tile.__index = Tile

setmetatable(Player, {
  __index = GameObject,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Tile:_init(x, y)
  GameActor:_init(x, y)

  self.type = "Tile"
end

function Tile:update(dt)
end

function Tile:draw()
end

function Item:isDead()
end

function Item:notifyCollision()
end

function Item:is(type)
  return type == self.type
end
