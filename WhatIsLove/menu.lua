local ARROW_X           = 100
local MENU_STRING_X     = 108
local NUMBER_OF_OPTIONS = 3

local MENU_STRINGS = {
	"PLAY",
  "OPTIONS",
  "EXIT"
}

function menuState:init()
  love.graphics.setBackgroundColor(184,199,145)
  selection = 1
end

function menuState:update()
end

function menuState:draw()
  love.graphics.push()
  love.graphics.scale(config.scale)

  love.graphics.setFont(font.bold)
	for i=1,NUMBER_OF_OPTIONS do
		if i == selection then
			love.graphics.print(">", ARROW_X, 86+i*13)
		end
		love.graphics.print(MENU_STRINGS[i], MENU_STRING_X, 86+i*13)
	end

  love.graphics.pop()
end

function menuState:keypressed(key)
  if key == "down" then
    selection = wrap(selection + 1, 1, NUMBER_OF_OPTIONS)
  elseif key == "up" then
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
