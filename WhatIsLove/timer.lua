Timer          = {}
Timer.__index  = Timer

setmetatable(Timer, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Timer:_init()
  self.time = 0
end

function Timer:update(dt)
  self.time = self.time + dt
end

function Timer:restart()
  self.time = 0
end

function Timer:get()
  return self.time
end

function Timer:set(time)
  self.time = time
end
