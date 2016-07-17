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

  self.name = "Tile"
end
