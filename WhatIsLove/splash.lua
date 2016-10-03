local transitionTime

function splashState:init()
  transitionTime = 0
end

function splashState:update(dt)
  transitionTime = transitionTime + dt
end

function splashState:draw()
  quad = {}
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  quad.screen = love.graphics.newQuad(0, 0, width, height, width, height)
  splashImage1 = love.graphics.newImage("img/love_splashpixel.png")
  splashImage2 = love.graphics.newImage("img/lovesplashpixel.png")

  if transitionTime < 4 then
    if transitionTime < 1 then
      local alpha = math.max(math.min(255*(transitionTime), 255), 0)
      love.graphics.setColor(255,255,255,alpha)
      love.graphics.draw(splashImage1, quad.screen, 0,0)
      love.graphics.setColor(255,255,255,255)
    elseif transitionTime > 3 then
      local alpha = math.max(math.min(255*(1-(transitionTime-3)), 255), 0)
			love.graphics.setColor(255,255,255,alpha)
			love.graphics.draw(splashImage1, quad.screen, 0,0)
			love.graphics.setColor(255,255,255,255)
    else
      love.graphics.draw(splashImage1, quad.screen, 0,0)
    end
  elseif transitionTime < 8 then
    if transitionTime < 5 then
      local alpha = math.max(math.min(255*(transitionTime-4), 255), 0)
      love.graphics.setColor(255,255,255,alpha)
      love.graphics.draw(splashImage2, quad.screen, 0,0)
      love.graphics.setColor(255,255,255,255)
    elseif transitionTime > 7 then
      local alpha = math.max(math.min(255*(1-(transitionTime-7)), 255), 0)
			love.graphics.setColor(255,255,255,alpha)
			love.graphics.draw(splashImage2, quad.screen, 0,0)
			love.graphics.setColor(255,255,255,255)
    else
      love.graphics.draw(splashImage2, quad.screen, 0,0)
    end
  else
    Gamestate.switch(menuState)
  end
end

function splashState:keypressed(key)
  if key == 'space'  or
     key == 'return' or
     key == 'escape' then
    Gamestate.switch(menuState)
  end
end
