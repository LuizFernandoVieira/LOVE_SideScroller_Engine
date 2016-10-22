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

-- Window Info
WIDTH  = 160
HEIGHT = 144

-- Debug Mode
debug = false

-- Requires
require("mobile")
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
require("bg_object")
require("player")
require("enemy")
require("chase_enemy")
require("rightleft_enemy")
require("flybomb_enemy")
require("def_shot_enemy")
require("bomb")
require("item")
require("ladder")
require("antidote")
require("bullet")
require("defshotenemies_bullets")
require("machinegun_bullet")
require("missle_bullet")
require("shotgun_bullet")
require("bite")
require("weapon")
require("gun")
require("shotgun")
require("misslegun")
require("machinegun")
require("map")
require("tile")
require("vector")
require("rect")
require("geometry_helper")
require("util")

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
