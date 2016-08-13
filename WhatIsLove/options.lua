local BACK_BTN_WIDTH           = 128
local BACK_BTN_HEIGHT          = 32

function optionsState:init()
  love.graphics.setBackgroundColor(255,255,255)
end

function optionsState:update(dt)
  updateSuitButtonBack()
end

function updateSuitButtonBack()
  buttonBack = suit.ImageButton(
    love.graphics.newImage(love.image.newImageData("img/menu/back.png")),
    love.graphics.getWidth()/2 - BACK_BTN_WIDTH/2,
    love.graphics.getHeight()/2
  )
  if buttonBack.hit then
    Gamestate.switch(menuState)
  end
  if buttonBack.hovered then
    Gamestate.switch(menuState)
  end
end

function optionsState:draw()
  love.graphics.push()
  love.graphics.scale(config.scale)

  suit.draw()

  love.graphics.pop()
end

function optionsState:keypressed(key)
  if key == "left" then
    config.scale = math.max(math.min(config.scale - 1, 5), 1)
  elseif key == "right" then
    config.scale = math.max(math.min(config.scale + 1, 5), 1)
  end
  setMode()
  print(config.scale)
  if key == 'escape' then
    Gamestate.switch(menuState)
  end
end
