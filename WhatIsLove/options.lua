local ARROW_X           = 100
local MENU_STRING_X     = 108
local NUMBER_OF_OPTIONS = 6

local OPTIONS_STRINGS = {
	"SCALE",
  "FULLSCREEN",
  "VSYNC",
  "SOUND VOLUME",
  "MUSIC VOLUME",
  "BACK"
}

function optionsState:init()
  selection = 1
end

function optionsState:update(dt)
end

function optionsState:draw()
  love.graphics.push()
  love.graphics.scale(config.scale)

  love.graphics.setFont(font.bold)

  love.graphics.print("SCALE:", 65, 63)
  love.graphics.print(config.scale, 167, 63)

	love.graphics.print("FULLSCREEN:", 65, 76)
	if config.fullscreen == 0 then		  love.graphics.print("OFF", 167, 76)
	elseif config.fullscreen == 1 then	love.graphics.print("FILL", 167, 76)
	elseif config.fullscreen == 2 then	love.graphics.print("ZOOM", 167, 76)
	else								                love.graphics.print("SCALE", 167, 76) end

	love.graphics.print("VSYNC:", 65, 89)
  love.graphics.print(config.vsync and "ON" or "OFF", 167, 89)

	love.graphics.print("SOUND VOL:", 65, 102)
	love.graphics.print("MUSIC VOL:", 65, 115)
	love.graphics.print("BACK", 65, 128)

	love.graphics.print(">", 52, 49+selection*13)

  love.graphics.pop()
end

function optionsState:keypressed(key)
  if key == "down" then
    selection = wrap(selection + 1, 1, NUMBER_OF_OPTIONS)
  elseif key == "up" then
    selection = wrap(selection - 1, 1, NUMBER_OF_OPTIONS)
  end

  if key == "left" or key == "right" then
    if selection == 1 then
      if key == "left" then
        config.scale = math.max(math.min(config.scale - 1, NUMBER_OF_OPTIONS), 1)
      elseif key == "right" then
        config.scale = math.max(math.min(config.scale + 1, NUMBER_OF_OPTIONS), 1)
      end
      setMode()
    end
  end

  if key == 'escape' then
    Gamestate.switch(menuState)
  end

  if key == "space" or key == "enter" or key == "return" then
    if selection == 6 then
      Gamestate.switch(menuState)
    end
  end
end
