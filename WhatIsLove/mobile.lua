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
    local lg = love.graphics

    if currentGameState == "gameState" then
      -- clicou esquerda
      if x > 90 and x < 230
      and y > lg.getHeight() - 620 and y < lg.getHeight() - 480 then
        player:setMovingLeft(true)
      end
      -- clicou direita
      if x > 580 and x < 720
      and y > lg.getHeight() - 620 and y < lg.getHeight() - 480 then
        player:setMovingRight(true)
      end

      -- clicou para movimentar para baixo
      if x > 335 and x < 475
      and y > lg.getHeight() - 360 and y < lg.getHeight() - 220 then
      end
      -- clicou para movimentar para cima
      if x > 335 and x < 475
      and y > lg.getHeight() - 875 and y < lg.getHeight() - 735 then
      end

      -- clicou para atirar
      if x > love.graphics.getWidth() -  710
      and x < love.graphics.getWidth() - 590
      and y > lg.getHeight() - 620 and y < lg.getHeight() - 480 then
        player:shot()
      end
      -- clicou para pular
      if x > love.graphics.getWidth() - 520
      and x < love.graphics.getWidth() - 400
      and y > lg.getHeight() - 360 and y < lg.getHeight() - 220 then
        player:jump()
      end
      -- clicou para dar dash
      if x > love.graphics.getWidth() - 220
      and x < love.graphics.getWidth() - 100
      and y > lg.getHeight() - 620 and y < lg.getHeight() - 480 then
        player:dash()
      end

    elseif currentGameState == "menuState" then

      -- clicou para movimentar para baixo
      if x > 400 and x < 520
      and y > 1140 and y < 1260 then
        selection = wrap(selection + 1, 1, 3)
      end
      -- clicou para movimentar para cima
      if x > 400 and x < 520
      and y > 624 and y < 745 then
        selection = wrap(selection - 1, 1, 3)
      end

      -- clicou para selecionar no play
      if x > love.graphics.getWidth()/2
      + love.graphics.getWidth()/4
      and selection == 1 then
        Gamestate.switch(gameState)
      end

      -- clicou para selecionar no options
      if x > love.graphics.getWidth()/2
      + love.graphics.getWidth()/4
      and selection == 2 then
        Gamestate.switch(optionsState)
      end

    elseif currentGameState == "optionsState" then

      -- clicou para movimentar para baixo
      if x > 400 and x < 520
      and y > 1140 and y < 1260 then
        selection = wrap(selection + 1, 1, 6)
      end
      -- clicou para movimentar para cima
      if x > 400 and x < 520
      and y > 624 and y < 745 then
        selection = wrap(selection - 1, 1, 6)
      end

      -- clicou esquerda
      if x > 100 and x < 220
      and y > 840 and y < 940 then

      end
      -- clicou direita
      if x > 590 and x < 710
      and y > 830 and y < 950 then

      end

      -- clicou para selecionar no back
      if x > love.graphics.getWidth()/2
      + love.graphics.getWidth()/4
      and selection == 6 then
        Gamestate.switch(menuState)
      end

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
  if love.system.getOS() == "Android"
  and currentGameState == "gameState" then
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
      lg.circle("fill", 405, lg.getHeight() - 805, 140, 100) -- cima   (345+465)/2
      lg.circle("fill", 405, lg.getHeight() - 290, 140, 100) -- baixo  (345+465)/2
      lg.circle("fill", 160, lg.getHeight() - 550, 140, 100) -- esq    (100+220)/2
      lg.circle("fill", 650, lg.getHeight() - 550, 140, 100) -- dir    (590+710)/2

      -- 405 => 335 e 475 | lg.getHeight() - 805 => lg.getHeight() - 735 e lg.getHeight() - 875 -- cima
      -- 405 => 335 e 475 | lg.getHeight() - 290 => lg.getHeight() - 220 e lg.getHeight() - 360 -- baixo
      -- 160 => 90  e 230 | lg.getHeight() - 550 => lg.getHeight() - 480 e lg.getHeight() - 620 -- esq
      -- 650 => 580 e 720 | lg.getHeight() - 550 => lg.getHeight() - 480 e lg.getHeight() - 620 -- dir

      lg.circle("fill", love.graphics.getWidth() - 405, lg.getHeight() - 805, 140, 100)
      lg.circle("fill", love.graphics.getWidth() - 405, lg.getHeight() - 290, 140, 100)
      lg.circle("fill", love.graphics.getWidth() - 160, lg.getHeight() - 550, 140, 100)
      lg.circle("fill", love.graphics.getWidth() - 650, lg.getHeight() - 550, 140, 100)
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
  love.graphics.draw(mobileCntrl, 1775, 500, 0, 1, 1)
  love.graphics.setColor( 255, 255, 255, 255 )
end



-- clicou para movimentar para baixo cima
-- 400  520   -> 410
-- clicou para movimentar para baixo
-- 1140 1260
-- clicou para movimentar para cima
-- 624 745
-- bla bla bla
-- 245 490

-- love.graphics.getHeight()
-- 1440

-- 635
-- 1150
-- (830+950)/2 = 890
-- (830+950)/2 = 890

-- 405 => 335 e 475 | lg.getHeight() - 805 => lg.getHeight() - 735 e lg.getHeight() - 875 -- cima
-- 405 => 335 e 475 | lg.getHeight() - 290 => lg.getHeight() - 220 e lg.getHeight() - 360 -- baixo
-- 160 => 90  e 230 | lg.getHeight() - 550 => lg.getHeight() - 480 e lg.getHeight() - 620 -- esq
-- 650 => 580 e 720 | lg.getHeight() - 550 => lg.getHeight() - 480 e lg.getHeight() - 620 -- dir
