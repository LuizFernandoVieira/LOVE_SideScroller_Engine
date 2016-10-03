-- DESENVOLVIMENTO DE JOGOS AVANÇADO
-- AUTOR: LUIZ FERNANDO VIEIRA DE CASTRO FERREIRA
-- UNIVERSIDADE NACIONAL DE BRASÍLIA

-- Game States
splashState    = {}
menuState      = {}
optionsState   = {}
gameState      = {}

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
require("sprite")
require("game_object")
require("game_actor")
require("player")
require("enemy")
require("item")
require("antidote")
require("bullet")
require("bite")
require("map")
require("tile")
require("vector")
require("rect")
require("geometry_helper")
require("util")

WIDTH = 256
HEIGHT = 200

function love.load()
  loadConfig()
  loadResources()
  setMode()
  Gamestate.registerEvents()
  Gamestate.switch(gameState)
end

function love.touchpressed(id, x, y, dx, dy, pressure)
  if love.system.getOS() == "Android" then
    if x < love.graphics.getWidth() / 2 then
      player:setMovingLeft(true)
    else
      player:setMovingRight(true)
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
  end
end
