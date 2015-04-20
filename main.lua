package.path = './lib/?.lua;' .. package.path

local basicgame = require('hug.basicgame')
local gameloop = require('hug.gameloop')
local menustate = require('states.menustate')

gameloop.fixint(30)
basicgame.start(menustate.new())

