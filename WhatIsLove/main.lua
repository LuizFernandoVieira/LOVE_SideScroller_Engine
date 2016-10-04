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
require("item")
require("ladder")
require("antidote")
require("bullet")
require("bite")
require("weapon")
require("gun")
require("shotgun")
require("lasergun")
require("map")
require("tile")
require("vector")
require("rect")
require("geometry_helper")
require("util")

WIDTH = 256
HEIGHT = 200
debug = false

function love.load(arg)
  loadDebug()
  loadConfig()
  loadResources()
  setMode()
  Gamestate.registerEvents()
  Gamestate.switch(gameState)
end

function loadDebug()
  if arg[2] == "debug" or
     arg[2] == "Debug" or
     arg[2] == "DEBUG" then
    print("Debug Mode On ...")
    debug = true
  end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
  if love.system.getOS() == "Android" then
    -- clicou esquerda
    if x > 100 and x < 220
    and y > 840 and y < 940 then
      player:setMovingLeft(true)
    -- clicou direita
    elseif x > 590 and x < 710
    and y > 830 and y < 950 then
      player:setMovingRight(true)
    -- clicou para pular
    elseif x > love.graphics.getWidth()/2 then
      player:jump()
    -- outros
    else
    end
  end
end

function love.touchreleased(id, x, y, dx, dy, pressure)
  if love.system.getOS() == "Android" then
    player:setMovingLeft(false)
    player:setMovingRight(false)
  end
end

function love.draw()
  if love.system.getOS() == "Android" then
    love.graphics.circle("fill", 410, 635, 100, 100)
    love.graphics.circle("fill", 410, 1150, 100, 100)
    love.graphics.circle("fill", 160, 890, 100, 100)
    love.graphics.circle("fill", 650, 890, 100, 100)
  end
end
