-- DESENVOLVIMENTO DE JOGOS AVANÇADO
-- Universidade Nacional de Brasília - UnB
-- @author Luiz Fernando Vieira de Castro Ferreira

-- Game States
splashState    = {}
menuState      = {}
optionsState   = {}
gameState      = {}
secondLevel    = {}
thirdLevel     = {}

-- Current Game State
currentGameState = "splashState"

-- Controls
joystick = {}

-- 3rd party libraries
Gamestate = require "hump.gamestate"
Camera    = require "hump.camera"
suit      = require "suit"

-- Requires
require("maps.first_map")
require("config")
require("resources")
require("splash")
require("options")
require("menu")
require("game")
require("second_level")
require("sprite")
require("game_object")
require("game_actor")
require("player")
require("enemy")
require("chase_enemy")
require("rightleft_enemy")
require("flybomb_enemy")
require("bomb")
require("item")
require("ladder")
require("antidote")
require("bullet")
require("missle_bullet")
require("bite")
require("weapon")
require("gun")
require("shotgun")
require("misslegun")
require("map")
require("tile")
require("vector")
require("rect")
require("geometry_helper")
require("util")

WIDTH = 256
HEIGHT = 200
debug = false

--- Initializes the hole game
-- First function called when love2d initializes
-- @param arg Argument passed in the command link
function love.load(arg)
  loadDebug()
  loadConfig()
  loadResources()
  setMode()
  Gamestate.registerEvents()
  Gamestate.switch(splashState)
end

--- Check if debug has been passed as a command line parameter
-- If so it makes the game run on debug mode
function loadDebug()
  if arg[2] == "debug" or
     arg[2] == "Debug" or
     arg[2] == "DEBUG" then
    print("Debug Mode On ...")
    debug = true
  end
end

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
