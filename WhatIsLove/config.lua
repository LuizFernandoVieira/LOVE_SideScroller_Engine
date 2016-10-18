default_config = {
  scale = 4,
  fullscreen = 0,
  vsync = true,
}

android_config = {
	scale = 10,
  fullscreen = 1,
  vsync = true,
}

--- Initializes the game according to the
-- configurations specified previously
function loadConfig()
  love.keyboard.setKeyRepeat(false)
  love.graphics.setDefaultFilter("nearest","nearest")

  joystick = love.joystick.getJoysticks()[1]
	config = {}

	if love.system.getOS() == "Android" then
			for i,v in pairs(android_config) do
			if type(v) == "table" then
				config[i] = {}
				for j,w in pairs(v) do
					config[i][j] = w
				end
			else
				config[i] = v
			end
		end
	else
		for i,v in pairs(default_config) do
			if type(v) == "table" then
				config[i] = {}
				for j,w in pairs(v) do
					config[i][j] = w
				end
			else
				config[i] = v
			end
		end
	end
end

--- Defines how the game is run
-- according to the fullscreen.
function setMode()
	local os = love.system.getOS()
  local lg = love.graphics
  local lw = love.window

	if  os == "Android" then
    local conf = {fullscreen=true, vsync=config.vsync}
    lw.setMode(lg.getWidth(), lg.getHeight(), conf)
  else
		if config.fullscreen == 0 then
      local conf = {fullscreen=false, vsync=config.vsync}
			lw.setMode(WIDTH*config.scale, HEIGHT*config.scale, conf)
			lg.setScissor()
		elseif config.fullscreen > 0 and config.fullscreen <= 3 then
      local conf = {fullscreen=true, vsync=config.vsync}
			lw.setMode(0,0, {fullscreen=true, vsync=config.vsync})
			lw.setMode(lg.getWidth(), lg.getHeight(), conf)
		end
		fs_translatex = (lg.getWidth()-WIDTH*config.scale)/2
		fs_translatey = (lg.getHeight()-HEIGHT*config.scale)/2
  end
end

--- Toggle VSync. Vsync is used to syncronize frame rate
-- produced by the GPU with the monitor update frequency.
-- That is done to avoid failures in the end image.
-- Activate VSync results in a "lag" and worst performace.
-- Disable VSync results in Screen Tearing.
function toggleVSync()
	config.vsync = not config.vsync
	setMode()
end
