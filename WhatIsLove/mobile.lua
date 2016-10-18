--- Checks if touch pressed and act on those commands
-- Only works on mobile devices
-- @param id
-- @param x
-- @param y
-- @param dx
-- @param dy
-- @param pressure
function love.touchpressed(id, x, y, dx, dy, pressure)
  if love.system.getOS() == "Android" then

    if currentGameState == "gameState" then
      -- clicou esquerda
      if x > 100 and x < 220
      and y > 840 and y < 940 then
        player:setMovingLeft(true)
      end
      -- clicou direita
      if x > 590 and x < 710
      and y > 830 and y < 950 then
        player:setMovingRight(true)
      end

      -- clicou para atirar
      if x > love.graphics.getWidth()/2
      and x < love.graphics.getWidth()/4 * 3 then
        player:shot()
      end
      -- clicou para pular
      if x > love.graphics.getWidth()/2
      + love.graphics.getWidth()/4 then
        player:jump()
      end

    elseif currentGameState == "menuState" then
      Gamestate.switch(gameState)
    elseif currentGameState == "splashState" then
      Gamestate.switch(menuState)
    end

  end
end

--- Checks if touch released and act on those releases
-- Only works on mobile devices
-- @param id
-- @param x
-- @param y
-- @param dx
-- @param dy
-- @param pressure
function love.touchreleased(id, x, y, dx, dy, pressure)
  if love.system.getOS() == "Android" then
    if x < love.graphics:getWidth()/2 then
      player:setMovingLeft(false)
      player:setMovingRight(false)
    end
  end
end

--- Draws objects
-- Handle the drowing of adicional controller
-- if running on mobile devices
function love.draw()
  if love.system.getOS() == "Android" then
    if currentGameState == "menuState" then
      love.graphics.setColor(0, 0, 0, 50)
    end

    if currentGameState ~= "splashState" then
      local lg = love.graphics
      lg.circle("fill", 410, 635, 100, 100)
      lg.circle("fill", 410, 1150, 100, 100)
      lg.circle("fill", 160, 890, 100, 100)
      lg.circle("fill", 650, 890, 100, 100)
    end
  end
end

function drawMobileTouches()
  if love.system.getOS() == "Android" then
    local touches = love.touch.getTouches()
    for i, id in ipairs(touches) do
        local x, y = love.touch.getPosition(id)
        local lg = love.graphics
        lg.setColor(0, 255, 0)
        lg.circle("fill", x, y, 20)
        lg.setColor(255, 255, 255)
    end
      drawMobileControler()
  end
end

--- Draws a controler on mobile devices
-- so the player can see where he should
-- click to activate ingame player actions.
function drawMobileControler()
  love.graphics.setColor( 255, 255, 255, 50 )
  love.graphics.draw(mobileCntrl, 25, 500, 0, 1, 1)
  love.graphics.setColor( 255, 255, 255, 255 )
end
