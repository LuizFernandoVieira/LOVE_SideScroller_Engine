default_config = {
  scale = 1,
  fullscreen = 0,
  vsync = true,
}

function loadConfig()
  love.keyboard.setKeyRepeat(false)

	config = {}
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

function setMode()
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

function toggleVSync()
	config.vsync = not config.vsync
	setMode()
end
