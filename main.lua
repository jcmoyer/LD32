package.path = './lib/?.lua;' .. package.path

local basicgame = require('hug.basicgame')
local gameloop = require('hug.gameloop')
local playstate = require('states.playstate')

gameloop.fixint(30)
basicgame.start(playstate.new())

