default_config = {
  scale = 4,
  fullscreen = 0,
  vsync = true,
}

android_config = {
	scale = 4,
  fullscreen = 1,
  vsync = true,
}

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

function setMode()
	local os = love.system.getOS()
	if  os == "Android" then
    love.window.setMode(love.graphics.getWidth(), love.graphics.getHeight(), {fullscreen=true, vsync=config.vsync})
  else
		if config.fullscreen == 0 then
			love.window.setMode(WIDTH*config.scale, HEIGHT*config.scale, {fullscreen=false, vsync=config.vsync})
			love.graphics.setScissor()
		elseif config.fullscreen > 0 and config.fullscreen <= 3 then
			love.window.setMode(0,0, {fullscreen=true, vsync=config.vsync})
			love.window.setMode(love.graphics.getWidth(), love.graphics.getHeight(), {fullscreen=true, vsync=config.vsync})
		end
		fs_translatex = (love.graphics.getWidth()-WIDTH*config.scale)/2
		fs_translatey = (love.graphics.getHeight()-HEIGHT*config.scale)/2
  end
end

function toggleVSync()
	config.vsync = not config.vsync
	setMode()
end
