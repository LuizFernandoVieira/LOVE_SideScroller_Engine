local transitionTime

---
--
function splashState:init()
  transitionTime = 0
end

---
--
-- @param dt Time passed since last update
function splashState:update(dt)
  transitionTime = transitionTime + dt
end

---
--
function splashState:draw()
  local quad = {}
  local lg = love.graphics
  local width = lg.getWidth()
  local height = lg.getHeight()
  quad.screen = lg.newQuad(0, 0, width, height, width, height)
  local splashImage1 = lg.newImage("img/splash.jpg")
  local splashImage2 = lg.newImage("img/lovesplashpixel.png")

  if transitionTime < 4 then
    if transitionTime < 1 then
      local min = math.min(255*(transitionTime), 255)
      local alpha = math.max(min, 0)
      lg.setColor(255,255,255,alpha)
      lg.draw(splashImage1, quad.screen, 0,0)
      lg.setColor(255,255,255,255)
    elseif transitionTime > 3 then
      local min = math.min(255*(1-(transitionTime-3)), 255)
      local alpha = math.max(min, 0)
			lg.setColor(255,255,255,alpha)
			lg.draw(splashImage1, quad.screen, 0,0)
			lg.setColor(255,255,255,255)
    else
      lg.draw(splashImage1, quad.screen, 0,0)
    end
  elseif transitionTime < 8 then
    if transitionTime < 5 then
      local min = math.min(255*(transitionTime-4), 255)
      local alpha = math.max(min, 0)
      lg.setColor(255,255,255,alpha)
      lg.draw(splashImage2, quad.screen, 0,0)
      lg.setColor(255,255,255,255)
    elseif transitionTime > 7 then
      local min = math.min(255*(1-(transitionTime-7)), 255)
      local alpha = math.max(min, 0)
			lg.setColor(255,255,255,alpha)
			lg.draw(splashImage2, quad.screen, 0,0)
			lg.setColor(255,255,255,255)
    else
      lg.draw(splashImage2, quad.screen, 0,0)
    end
  else
    Gamestate.switch(menuState)
  end
end

---
--
-- @param key
function splashState:keypressed(key)
  if key == 'space'  or
     key == 'return' or
     key == 'escape' then
    Gamestate.switch(menuState)
  end
end
