local module = require('hug.module')
local gamestate = require('hug.gamestate')

local gameoverstate = module.new(gamestate)

local ui = love.graphics.newImage('assets/ui.png')
local rabbit = love.graphics.newImage('assets/rabbit.png')

local font = love.graphics.newFont(24)

function gameoverstate.new(win, score)
  local instance = {
    win = win,
    score = score
  }
  return setmetatable(instance, gameoverstate)
end

function gameoverstate:update(dt)
end

function gameoverstate:keypressed(key)
  if key == 'return' then
    self:sm():pop()
  end

  if key == 'escape' then
    love.event.quit()
  end
end

function gameoverstate:draw(a)
  love.graphics.setFont(font)

  local sw, sh = love.graphics.getWidth(), love.graphics.getHeight()

  do
    local t = 'Your score was ' .. self.score .. '.'
    local tw = font:getWidth(t)
    local th = font:getHeight()
    love.graphics.print(t, sw / 2 - tw / 2, sh / 2 - th / 2 - 40)
  end

  do
    local t
    if self.win then
      t = 'You win!'
    else
      t = 'Game Over'
    end
    local tw = font:getWidth(t)
    local th = font:getHeight()
    love.graphics.print(t, sw / 2 - tw / 2, sh / 2 - th / 2 - 80)
  end

  do
    local tw = font:getWidth('Press ENTER to play again')
    local th = font:getHeight()
    love.graphics.print('Press ENTER to play again', sw / 2 - tw / 2, sh / 2 - th / 2 + 40)
  end

  do
    local tw = font:getWidth('Press ESC to quit')
    local th = font:getHeight()
    love.graphics.print('Press ESC to quit', sw / 2 - tw / 2, sh / 2 - th / 2 + 80)
  end
end

return gameoverstate
