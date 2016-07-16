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

function love.load()
  loveConfigurations()
  Gamestate.registerEvents()
  Gamestate.switch(splashState)
end

function loveConfigurations()
  love.keyboard.setKeyRepeat(false)
end
