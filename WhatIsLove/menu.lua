local SINGLE_PLAYER_BTN_WIDTH  = 128
local SINGLE_PLAYER_BTN_HEIGHT = 32
local BACK_BTN_WIDTH           = 128
local BACK_BTN_HEIGHT          = 32
local MARGIN_TOP               = 64

function menuState:init()
  love.graphics.setBackgroundColor(184,199,145)
end

function menuState:update()
  updateSuitButtonSinglePlayer()
  updateSuitButtonBack()
end

function menuState:draw()
  suit.draw()
end

function updateSuitButtonSinglePlayer()

  buttonSinglePlayer = suit.ImageButton(
    love.graphics.newImage(love.image.newImageData("img/menu/play.png")),
    love.graphics.getWidth()/2 - BACK_BTN_WIDTH/2,
    love.graphics.getHeight()/2
  )

  if buttonSinglePlayer.hit then
    print "hit"
    Gamestate.switch(gameState)
  end

  if buttonSinglePlayer.entered then
    print "entered"
  end

  if buttonSinglePlayer.hovered then
    print "hovered"
    Gamestate.switch(gameState)
  end

  if buttonSinglePlayer.left then
    print "entered"
  end
end

function updateSuitButtonBack()
  buttonBack = suit.ImageButton(
    love.graphics.newImage(love.image.newImageData("img/menu/back.png")),
    love.graphics.getWidth()/2 - BACK_BTN_WIDTH/2,
    love.graphics.getHeight()/2 + MARGIN_TOP
  )
  if buttonBack.hit then
    Gamestate.switch(menuState)
  end
end