GameActor         = {}
GameActor.__index = GameActor

setmetatable(GameActor, {
  __index = GameObject,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function GameActor:_init(x, y)
  GameObject._init(self, x, y)
end
