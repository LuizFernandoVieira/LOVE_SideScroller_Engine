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

local selectSound = love.audio.newSource("audio/select.wav")

--- Initializes the options state.
function optionsState:init()
  currentGameState = "optionsState"
  selection = 1
end

--- Updates the options state.
-- Called once once each love.update.
-- @param dt Time passed since last update
function optionsState:update(dt)
end

--- Draws all gui that belong to the options state screen.
-- Called once once each love.draw.
function optionsState:draw()
  local lg = love.graphics
  lg.push()

  setZoom()
  lg.scale(config.scale)

  lg.setFont(font.bold)

  lg.print("SCALE:", 65, 63)
  lg.print(config.scale, 167, 63)

	lg.print("FULLSCREEN:", 65, 76)
	if     config.fullscreen == 0 then lg.print("OFF", 167, 76)
	elseif config.fullscreen == 1 then lg.print("FILL", 167, 76)
	elseif config.fullscreen == 2 then lg.print("ZOOM", 167, 76)
	else								               lg.print("SCALE", 167, 76) end

	lg.print("VSYNC:", 65, 89)
  lg.print(config.vsync and "ON" or "OFF", 167, 89)

	lg.print("SOUND VOL:", 65, 102)
	lg.print("MUSIC VOL:", 65, 115)
	lg.print("BACK", 65, 128)

	lg.print(">", 52, 49+selection*13)

  lg.pop()
  lg.setScissor()
end

--- Checks for keyboard presses.
-- @param key
function optionsState:keypressed(key)
  selectSound:play()

  if key == "down" or key == "s" then
    selection = wrap(selection + 1, 1, NUMBER_OF_OPTIONS)
  elseif key == "up" or key == "w" then
    selection = wrap(selection - 1, 1, NUMBER_OF_OPTIONS)
  end

  if key == "left" or key == "right"  or key == "a" or key == "d" then
    -- SCALE
    if selection == 1 then
      if key == "left" or key == "a" then
        local min = math.min(config.scale - 1, NUMBER_OF_OPTIONS)
        config.scale = math.max(min, 1)
      elseif key == "right" or key == "d" then
        local min = math.min(config.scale + 1, NUMBER_OF_OPTIONS)
        config.scale = math.max(min, 1)
      end
      setMode()
    -- FULLSCREEN
    elseif selection == 2 then
      if key == "left" or key == "a" then
        if config.fullscreen > 0 then
          config.fullscreen = cap(config.fullscreen - 1, 0, 3)
          setMode()
        end
      elseif key == "right" or key == "d" then
        if config.fullscreen < 3 then
          config.fullscreen = cap(config.fullscreen + 1, 0, 3)
          setMode()
        end
      end
    -- VSYNC
    elseif selection == 3 then
      config.vsync = not config.vsync
      setMode()
    -- SOUND
    elseif selection == 4 then

    -- MUSIC
    elseif selection == 5 then
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

--- Checks for gamepad presses.
-- @param joystick
-- @param button
function optionsState:gamepadpressed(joystick, button)
  if button == "dpdown" then
    selection = wrap(selection + 1, 1, NUMBER_OF_OPTIONS)
  elseif button == "dpup" then
    selection = wrap(selection - 1, 1, NUMBER_OF_OPTIONS)
  end

  if button == "dpleft" or button == "dpright" then
    if selection == 1 then
      if button == "dpleft" then
        local min = math.min(config.scale - 1, 4)
        config.scale = math.max(min, 1)
      elseif button == "dpright" then
        local min = math.min(config.scale + 1, 4)
        config.scale = math.max(min, 1)
      end
      setMode()
    elseif selection == 2 then
      if button == "dpleft" then
        if config.fullscreen > 0 then
          config.fullscreen = cap(config.fullscreen - 1, 0, 3)
          setMode()
        end
      else
        if config.fullscreen < 3 then
          config.fullscreen = cap(config.fullscreen + 1, 0, 3)
          setMode()
        end
      end
    elseif selection == 3 then
      config.vsync = not config.vsync
      setMode()
    end
  end

  if button == "a" then
    if selection == 6 then
      Gamestate.switch(menuState)
    end
  end
end
