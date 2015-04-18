local module = require('hug.module')
local gamestate = require('hug.gamestate')

local playstate = module.new(gamestate)

function playstate.new()
  return setmetatable({}, playstate)
end

function playstate:draw(a)
  love.graphics.print('hello world', 0, 0)
end

return playstate
