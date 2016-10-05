local ARROW_X           = 100
local MENU_STRING_X     = 108
local NUMBER_OF_OPTIONS = 3

local MENU_STRINGS = {
	"PLAY",
  "OPTIONS",
  "EXIT"
}

---
--
function menuState:init()
  love.graphics.setBackgroundColor(184,199,145)
  selection = 1

  if love.system.getOS() == "Android" then
    love.system.vibrate(2)
  end
end

---
--
function menuState:update()
end

---
--
function menuState:draw()
  love.graphics.push()

  setZoom()
  love.graphics.scale(config.scale)

  love.graphics.setFont(font.bold)
	for i=1,NUMBER_OF_OPTIONS do
		if i == selection then
			love.graphics.print(">", ARROW_X, 86+i*13)
		end
		love.graphics.print(MENU_STRINGS[i], MENU_STRING_X, 86+i*13)
	end

  love.graphics.pop()
  love.graphics.setScissor()
end

---
--
-- @param key
function menuState:keypressed(key)
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

---
--
-- @param joystick
-- @param button
function menuState:gamepadpressed(joystick, button)
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
