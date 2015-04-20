local module = require('hug.module')
local gamestate = require('hug.gamestate')

local pausestate = module.new(gamestate)

local font = love.graphics.newFont(24)

function pausestate.type(t)
  if getmetatable(t) == pausestate then
    return 'pausestate'
  else
    return nil
  end
end

function pausestate.new()
  local instance = {
    transparent = true
  }
  return setmetatable(instance, pausestate)
end

function pausestate:keypressed(key)
  if key == 'escape' then
    self:sm():pop()
  end
  if key == 'q' then
    love.event.quit()
  end
end

function pausestate:draw(a)
  local sw, sh = love.graphics.getWidth(), love.graphics.getHeight()
  do
    local t = 'Paused; press ESC to return to the game or Q to quit.'
    local tw = font:getWidth(t)
    local th = font:getHeight()
    love.graphics.setFont(font)
    love.graphics.print(t, sw / 2 - tw / 2, sh / 2 - th / 2)
  end
  return true
end

return pausestate
