local ARROW_X           = 50
local MENU_STRING_X     = 58
local NUMBER_OF_OPTIONS = 3

local MENU_STRINGS = {
	"PLAY",
  "OPTIONS",
  "EXIT"
}

local selectSound = love.audio.newSource("audio/select.wav")

--- Initializes the menu state.
function menuState:init()
  currentGameState = "menuState"
  love.graphics.setBackgroundColor(230, 214, 156)
  selection = 1

  if love.system.getOS() == "Android" then
    love.system.vibrate(2)
  end
end

--- Updates the menu state.
-- Called once once each love.update.
-- @param dt Time passed since last update
function menuState:update(dt)
end

--- Draws all gui that belong to the menu state screen.
-- Called once once each love.draw.
function menuState:draw()
  love.graphics.push()

  setZoom()
  love.graphics.scale(config.scale)

  love.graphics.setColor(123, 114, 99)
  love.graphics.setFont(font.bold)

	for i=1,NUMBER_OF_OPTIONS do
		if i == selection then
			love.graphics.print(">", ARROW_X, 60+i*13)
		end
		love.graphics.print(MENU_STRINGS[i], MENU_STRING_X, 60+i*13)
	end

  love.graphics.pop()
  love.graphics.setScissor()
end

--- Checks for keyboard presses.
-- @param key
function menuState:keypressed(key)
  selectSound:play()

  if key == "down" or key == "s" then
    selection = wrap(selection + 1, 1, NUMBER_OF_OPTIONS)
  elseif key == "up" or key == "w" then
    selection = wrap(selection - 1, 1, NUMBER_OF_OPTIONS)
  end

  if key == "space" or key == "enter" or key == "return" then
    if selection == 1 then
      Gamestate.switch(gameState)
    elseif selection == 2 then
      Gamestate.switch(optionsState)
    elseif selection == 3 then
      love.event.quit()
    end
  end
end

--- Checks for gamepad presses.
-- @param joystick
-- @param button
function menuState:gamepadpressed(joystick, button)
  selectSound:play()

  if button == "dpdown" then
    selection = wrap(selection + 1, 1, NUMBER_OF_OPTIONS)
  elseif button == "dpup" then
    selection = wrap(selection - 1, 1, NUMBER_OF_OPTIONS)
  end

  if button == "a" then
    if selection == 1 then
      Gamestate.switch(gameState)
    elseif selection == 2 then
      Gamestate.switch(optionsState)
    elseif selection == 3 then
      love.event.quit()
    end
  end
end
