-- Game States
splashState    = {}
menuState      = {}
gameState      = {}

-- 3rd party libraries
Gamestate = require "hump.gamestate"
suit      = require "suit"

-- Requires
require("maps.first_map")
require("splash")
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

function love.load()
  loveConfigurations()
  Gamestate.registerEvents()
  Gamestate.switch(gameState)
end

function loveConfigurations()
  love.keyboard.setKeyRepeat(false)
end
