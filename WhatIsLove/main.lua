-- DESENVOLVIMENTO DE JOGOS AVANÇADO
-- AUTOR: LUIZ FERNANDO VIEIRA DE CASTRO FERREIRA
-- UNIVERSIDADE NACIONAL DE BRASÍLIA

-- Game States
splashState    = {}
menuState      = {}
optionsState   = {}
gameState      = {}

-- 3rd party libraries
Gamestate = require "hump.gamestate"
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
  Gamestate.switch(menuState)
end
